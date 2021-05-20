module SyntaxHighlighting
  class Parser
    # - parameter language: `Language`
    #
    def initialize(language)
      @language = language
    end

    # Get a list of pattern names from a line of text. The pattern names should
    # be associated with the characters of the line of text.
    #
    # - parameter line_of_text: LineOfText
    #
    def pattern_names_for_line(line_of_text, parent = nil)
      raise "line_of_text not found for parsing" if line_of_text.nil?

      patterns = parent.patterns if parent
      patterns ||= @language.patterns
      result = nil

      # warn "parsing #{line_of_text.to_s.inspect} (FOR BEGIN) with #{patterns.count} patterns"

      first_begin_match = nil
      first_begin_index = line_of_text.length

      # If we find a `begin` that matches, we want to stop looking for other
      # patterns matching the whole line. We want to basically search the
      # remainder of the line until we also then find the next corresponding
      # `end` match.
      #
      # If the remainder of this line doesn't match the `end`, we'll continue
      # using `LineOfText#next_line` until we have met one.
      #
      # In addition to looking for an `end` match, the pattern can also have
      # children patterns itself. While searching for the `end`, we can also
      # these children patterns agaisn't the remainder of the line, or any
      # following lines, up until the `end` match.
      each_pattern(patterns) do |pattern|
        next unless pattern.begin

        match = line_of_text.match(pattern.begin)

        next unless match

        index = match.offset(0).first

        next unless index < first_begin_index

        first_begin_index = index
        first_begin_match = pattern
      end

      if first_begin_match
        pattern = first_begin_match

        # If there's no name or captures, the only purpose for this pattern
        # must be to have child patterns rather than tagging any characters
        # itself, so there's no point looking for references, but we should
        # still handle it if we got the regex match.
        skip_references = skip_references?(
          line_of_text,
          pattern,
          pattern.begin_captures || pattern.captures
        )
        if skip_references
          start_index = line_of_text.match(pattern.begin).offset(0).first
          handle_begin(line_of_text, parent, pattern, start_index)
          return
        end

        references = handle_regex(
          line_of_text,
          pattern.begin,
          pattern.name,
          pattern.begin_captures || pattern.captures,
          true
        )

        # If this is true, we've found the `begin` match, so our search for
        # an `end` begins here.
        if references && references.count > 0
          start_index = line_of_text.character_metadata.index(references.last) + 1

          # Before handling the begin, make sure we cover the line before the
          # begin. In particular, we know this part wont have any more begins,
          # but it could still have regular matches.
          sub_line_ending = line_of_text.character_metadata.index(references.first) - 1
          if sub_line_ending > -1
            sub_line = SubLineOfText.new(line_of_text, 0, sub_line_ending)
            pattern_names_for_line(sub_line, parent)
          end

          # Handle the begin to search for the end, and fill in any child
          # patterns in between.
          handle_begin(line_of_text, parent, pattern, start_index)

          # We shouldn't look for any more patterns at this point; instead we
          # leave the child patterns to do everything else from here.
          return
        elsif references && pattern.patterns
          # Some regexes 0 have results, but still need handling to cover child
          # patterns.
          # E.g. `punctuation.whitespace.comment.leading.ruby`
          pattern_names_for_line(line_of_text, pattern)
          return
        end
      end

      # If we didn't hit a `begin`, and we have a parent, we should apply the
      # parent's `name`.
      if parent && parent.name
        handle_regex(
          line_of_text,
          /(.*)/,
          parent.name,
          nil
        )
      end

      # warn "parsing #{line_of_text.to_s.inspect} (BEYOND BEGIN) with #{patterns.count} patterns"

      # Because we've already dealt with `begin`s, any patterns matched here can
      # match agaisnt the whole line.
      each_pattern(patterns) do |pattern|
        next if pattern.begin

        if pattern.match
          # `match` — a regular expression which is used to identify the portion
          # of text to which the name should be assigned
          handle_regex(
            line_of_text,
            pattern.match,
            pattern.name,
            pattern.captures
          )
        end
      end
    end

    private

    # - returns the list of mutated SyntaxHighlighting::CharacterMetadata
    #
    def handle_regex(line_of_text, regex, name, captures, first_only = false)
      if first_only
        match = line_of_text.match(regex)
        matches = [match] if match
      else
        matches = line_of_text.matches(regex)
      end

      # Ignore if the regex doesn't match.
      return nil if matches.nil? || matches.empty?

      references = []

      # If there are no captures (specific characters), use the pattern name for
      # all characters within the bounds of the match.
      if name
        matches.each do |match|
          start_index, end_index = match.offset(0)
          line_of_text.character_metadata[start_index...end_index].map do |meta|
            # warn "    tagging #{meta} with #{name}"
            meta.find_or_create_reference(name)
            references << meta
          end
        end
      end

      return references if !captures

      # If there are captures, only assign the relevant names to the
      # corresponding characters.
      captures.each do |index, name|
        matches.each do |match|
          next if index > match.length - 1

          begin_char, end_char = match.offset(index)

          next if !begin_char && !end_char

          line_of_text.character_metadata[begin_char...end_char].each do |meta|
            # warn "    tagging #{meta} with #{name}"
            meta.find_or_create_reference(name)
            references << meta
          end
        end
      end

      references.flatten
    end

    # `handle_regex` has already been called at this point, so we've set
    # character names for begin.
    #
    def handle_begin(line_of_text, parent_pattern, pattern, start_index)
      # We first want to make sure we're only handling the remainder of the
      # line of text.
      # warn "  We're in a begin"

      remainder = SubLineOfText.new(line_of_text, start_index, -1)

      # warn "  searching for end in: #{remainder}"

      skip_references = skip_references?(
        remainder,
        pattern,
        pattern.end_captures || pattern.captures
      )

      # TODO: end back_references
      end_references = handle_regex(
        remainder,
        pattern.end,
        pattern.name,
        pattern.end_captures || pattern.captures,
        true
      ) unless skip_references

      sub_start = start_index
      sub_end = -1
      found_end = false
      after_end_sub_start = nil

      # If we've found `end` on this same line, we want to find child patterns
      # for only the bit between `begin` and `end`.
      if skip_references && match = remainder.match(pattern.end)
        # warn "  We've found the funky end"
        sub_end = match.offset(0).first
        after_end_sub_start = sub_end + 1
        found_end = true
      elsif skip_references
        # no end found
      elsif end_references && end_references.count > 0
        # warn "  We've found the end"
        sub_end = line_of_text.character_metadata.index(end_references.first) - 1
        after_end_sub_start = line_of_text.character_metadata.index(end_references.last) + 1
        found_end = true
      end

      # Search for child patterns
      sub_line = SubLineOfText.new(line_of_text, sub_start, sub_end)
      pattern_names_for_line(sub_line, pattern) if sub_line.length > 0

      # Also if we've found `end` on this same line, parse the rest of the line
      # as normal.
      if found_end
        after_end_sub_end = -1
        sub_line = SubLineOfText.new(line_of_text, after_end_sub_start, after_end_sub_end)
        pattern_names_for_line(sub_line, parent_pattern) if sub_line.length > 0
        return
      end

      # If we haven't found end on this same line, we need to start searching
      # for it on the next. If there is a next. If there isn't, then we just
      # drop it.
      handle_begin(line_of_text.next_line, parent_pattern, pattern, 0) if line_of_text.next_line
    end

    def each_pattern(patterns, &blk)
      patterns.each do |pattern|
        if pattern.begin
          blk.call(pattern)
        elsif pattern.match
          blk.call(pattern)
        elsif pattern.patterns.count > 0
          each_pattern(pattern.patterns, &blk)
        end
      end
    end

    def skip_references?(line_of_text, pattern, captures)
      !pattern.name &&
        !captures &&
        line_of_text.match(pattern.begin)
    end
  end
end

module SyntaxHighlighting
  # Represents a part of a `LineOfText`. Specifically providing the same API as
  # `LineOfText` itself. Therefore, can also be used as a sub-sub-line of text.
  #
  class SubLineOfText
    # - parameter line_of_text: Parent `LineOfText` or `SubLineOfText`.
    #
    def initialize(line_of_text, start_index, end_index)
      @line_of_text = line_of_text
      @start_index = start_index
      @end_index = end_index
      @text = line_of_text.to_s[@start_index..@end_index]
      @next_line = line_of_text.next_line if end_index == -1 || end_index >= line_of_text.length - 1
      @length = @text.length
    end

    # Returns the next line. Note: because this is a sub-line, this'll only have
    # a result if the sub-line is up to the end of the original line of text.
    #
    attr_reader :next_line

    attr_reader :length

    # Returns a collection containing character metadata that belongs to the
    # parent line of text.
    #
    # - returns: [CharacterMetaData]
    #
    def character_metadata
      @line_of_text.character_metadata[@start_index..@end_index]
    end

    def to_s
      @text
    end

    def match(*args)
      @text.match(*args)
    end

    def matches(regex)
      @text.to_enum(:scan, regex).map { Regexp.last_match }
    end

    def inspect
      "<SubLineOfText\n#{to_s.inspect}\n[\n#{character_metadata.join("\n")}\n]>"
    end
  end
end

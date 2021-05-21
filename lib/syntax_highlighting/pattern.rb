module SyntaxHighlighting
  # A child object to `Language`; repesenting a pattern from a tmLanguage file.
  #
  # A pattern can have children patterns; thereby making a tree structure.
  #
  class Pattern
    # Checks to see if there is an "include" in the pattern:
    # * If there is an "include", the repository is used to use a reusable
    #   pattern.
    # * If not, a new one will be initialized.
    #
    def self.find_or_initialize(contents, repository)
      return contents if contents.is_a?(Language)

      if contents.key?("include")
        key = contents["include"]
        result = repository.get(key)

        if result.nil?
          warn "Could not find #{key} in repository. Available keys: #{repository.keys}"
          result = new({ "name" => "skipped.skipped.skipped" }, repository)
        end

        result
      else
        new(contents, repository)
      end
    end

    # Build a pattern from a hash.
    #
    # - parameter contents: Hash
    # - parameter parent_repository: Repository
    #
    def initialize(contents, parent_repository = nil)
      @contents = contents

      if contents.key?("include")
        # If you're falling into this error, you should be using
        # `.find_or_intiailize_by`.
        raise "A pattern is referencing a repository but was called to be " +
          "initialized."
      end

      if contents.key?("repository")
        @repository = Repository.new(contents["repository"], parent_repository)
      else
        @repository = parent_repository
      end

      begin
        Warnings.silence do
          @begin = Regexp.new(contents["begin"]) if contents["begin"]
        end
      rescue RegexpError
        warn "Unhandled regex in language: #{repository.get("$self")&.name || "UNKNOWN"}"
      end

      @end = contents["end"]
      begin
        @begin_captures = Captures.new(contents["beginCaptures"]) if contents["beginCaptures"]
      rescue UnhandledCapturesError
        warn "Unhandled captures in language: #{repository.get("$self")&.name || "UNKNOWN"}"
      end
      begin
        @end_captures = Captures.new(contents["endCaptures"]) if contents["endCaptures"]
      rescue UnhandledCapturesError
        warn "Unhandled captures in language: #{repository.get("$self")&.name || "UNKNOWN"}"
      end
      @content_name = contents["contentName"]
      @name = contents["name"].to_sym if contents["name"]



      begin
      @captures = Captures.new(contents["captures"]) if contents["captures"]
      rescue UnhandledCapturesError
        warn "Unhandled captures in language: #{repository.get("$self")&.name || "UNKNOWN"}"
      end

      begin
        Warnings.silence do
          @match = Regexp.new(contents["match"]) if contents["match"]
        end
      rescue RegexpError
        warn "Unhandled regex in language: #{repository.get("$self")&.name || "UNKNOWN"}"
      end

      if contents["patterns"] && @match && contents["patterns"].count > 0
        warn "Unexpected children on match style pattern in language: #{repository.get("$self")&.name || "UNKNOWN"}"
      end
    end

    # `begin` and `end` allow rules that match multiple lines. If a `begin` is
    # found on an earlier line an `end` match can be made on a following line.
    #
    # Notably, the `end` regex is dynamic; it contains back references to values
    # from the result of match for `begin`.
    #
    attr_reader :begin

    # See `#begin`.
    #
    # - parameter back_references: { n => String }
    #
    def end(back_references = nil)
      return Regexp.new(@end) unless back_references

      regex = "#{@end}"

      back_references.each do |index, value|
        regex.gsub!("\\#{index}", value)
      end

      Regexp.new(regex)
    end

    # Captures, but for the `#begin` regex.
    #
    # See `#captures`.
    #
    attr_reader :begin_captures

    # Captures, but for the `#end` regex.
    #
    # See `#captures`.
    #
    attr_reader :end_captures

    # TODO: ? What is this?
    #
    attr_reader :content_name

    # The identifier used to match up with the theme (or useful for an editor
    # to have more context of the language).
    #
    # A name could look like:
    #   `"punctuation.definition.variable.ruby"`
    # whereas a theme might define with less dots:
    #   `"punctuation.definition.variable"`
    # and still match.
    #
    attr_reader :name

    # Names for specific parts of a match (with `#match`). See `#name`.
    #
    # ```
    # {
    #   "1": {
    #     "name": "punctuation.definition.variable.ruby"
    #   }
    # }
    # ```
    attr_reader :captures

    # Regex to actually match agaisnt a single line of code.
    #
    attr_reader :match

    # Child patterns.
    #
    def patterns
      @patterns ||= lazy_patterns
    end

    # See `Language#repository`.
    #
    attr_reader :repository

    def inspect
      type = "empty"
      type = "begin" if self.begin
      type = "match" if self.match
      "<Pattern : #{type} : #{patterns.count} children>"
    end

    private

    def lazy_patterns
      patterns = []
      return [] unless @contents.key?("patterns")
      @contents["patterns"].each do |pattern_contents|
        pattern = Pattern.find_or_initialize(pattern_contents, repository)
        patterns << pattern
      end

      if patterns.count > 0 && match && self.begin.nil? && self.end.nil?
        # The documentation says:
        #
        # > A begin/end rule can have nested patterns using the patterns key
        #
        # but doesn't say anything about patterns with a `match` having nested
        # patterns.
        raise "Unexpected children"
      end

      patterns.freeze
    end
  end
end

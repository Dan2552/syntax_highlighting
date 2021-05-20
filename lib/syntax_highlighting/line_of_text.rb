module SyntaxHighlighting
  # Represents a line of text that can be drawn to screen. Contains metadata
  # agaisnt each character for any formatting (e.g. color, bold, etc).
  #
  class LineOfText
    # Build one or more lines of text (i.e. seperated by newline), with double-
    # linked lists.
    #
    # - returns: `LineOfText` for the first line of text.
    #
    def self.build(text)
      first_line = nil
      previous_line = nil

      text.each_line do |text_line|
        new_line = new(text_line)
        first_line = new_line unless first_line
        new_line.previous_line = previous_line
        previous_line = new_line
      end

      first_line
    end

    # - parameter text: String
    #
    def initialize(text)
      @text = text.dup.freeze
      @length = text.length
    end

    attr_reader :next_line
    attr_reader :previous_line
    attr_reader :length

    # The character metadata store.
    #
    # - returns: [CharacterMetaData]
    #
    def character_metadata
      @character_metadata ||= @length.times.map do |index|
        CharacterMetadata.new(index, self)
      end.freeze
    end

    def match(*args)
      @text.match(*args)
    end

    def matches(regex)
      @text.to_enum(:scan, regex).map { Regexp.last_match }
    end

    def to_s
      @text
    end

    def inspect
      "<LineOfText\n#{to_s.inspect}\n[\n#{character_metadata.join("\n")}\n]>"
    end

    def previous_line=(set)
      @previous_line = set
      return unless set
      set.next_line_without_next_line_ref = self
    end

    def next_line=(set)
      @next_line = set
      return unless set
      set.previous_line_without_next_line_ref = self
    end

    def previous_line_without_next_line_ref=(set)
      @previous_line = set
    end

    def next_line_without_next_line_ref=(set)
      @next_line = set
    end

    def to_html
      character_metadata.map.with_index do |meta, index|
        color = nil

        meta.theme_rules.each do |rule|
          color ||= rule.foreground
        end

        color ||= "black"
        if @text[index] == "\n"
          ""
        else
          "<span style=\"color:#{color}\">#{@text[index]}</span>"
        end
      end.join("")
    end
  end
end

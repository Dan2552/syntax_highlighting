module SyntaxHighlighting
  # A child object to `Pattern`; repesenting a captures from a tmLanguage file.
  #
  class Captures
    def initialize(contents)
      @store = {}

      contents.each do |number_identifier, values|
        raise UnhandledCapturesError if values["name"].nil?
        @store[number_identifier.to_i] = values["name"].to_sym
      end
    end

    # - block: yields Integer, String
    #
    def each(&blk)
      @store.each(&blk)
    end

    def [](index)
      @store[index]
    end

    def inspect
      @store.inspect
    end

    def to_s
      inspect
    end
  end
end

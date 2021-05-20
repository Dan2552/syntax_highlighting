module SyntaxHighlighting
  class CharacterMetadata
    def initialize(index, line_of_text)
      @index = index
      @line_of_text = line_of_text
    end

    attr_reader :index

    def theme_rules
      @theme_rules ||= []
    end

    def find_or_create_reference(name)
      reference = store.find { |ref| ref == name }
      return reference  if reference
      store << name
    end

    def references
      store.dup.freeze
    end

    def inspect
      "<char #{@index.to_s.ljust(2)} : #{@line_of_text.to_s[@index]} : #{store.map(&:inspect).join(",")}>"
    end

    def to_s
      inspect
    end

    private

    def store
      @store ||= []
    end
  end
end

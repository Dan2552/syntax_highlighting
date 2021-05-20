module SyntaxHighlighting
  class Highlighter
    def initialize(config = SyntaxHighlighting.config)
      raise "theme_file not setup in config" unless config.theme_file
      raise "theme_file not setup in config" unless config.language_files

      @repository = SyntaxHighlighting::MultiLanguageRepository.new(config.language_files)

      theme_contents = JSON.parse(File.read(config.theme_file))
      theme = SyntaxHighlighting::Theme.new(theme_contents)
      @applicator = SyntaxHighlighting::ThemeApplicator.new(theme)
    end

    def parse(line_of_text, language_name)
      line_of_text = LineOfText.new(line_of_text) if line_of_text.is_a?(String)
      language = @repository.get("source.#{language_name}")
      raise "language #{language_name} not found" unless language
      parser = (parsers[language] ||= SyntaxHighlighting::Parser.new(language))
      parser.pattern_names_for_line(line_of_text)
      @applicator.apply(line_of_text)
      line_of_text
    end

    def inspect
      "#<Highlighter>"
    end

    private

    def parsers
      @parsers ||= {}
    end
  end
end

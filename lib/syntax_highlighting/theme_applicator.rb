module SyntaxHighlighting
  class ThemeApplicator
    # - parameter theme: `Theme`
    #
    def initialize(theme)
      @theme = theme
    end

    def apply(line_of_text)
      line_of_text.character_metadata.each do |meta|
        meta.references.each do |name|
          find_rules(name.to_s).each do |rule|
            meta.theme_rules << rule
          end
        end
      end
    end

    private

    def find_rules(scope)
      return [] unless scope
      rules = @theme.scopes[scope]
      return rules if rules
      return [] unless scope.include?(".")
      shorter_scope = scope.gsub(/\.[a-zA-Z\-]+$/, "")
      return [] if scope == shorter_scope
      find_rules(shorter_scope)
    end
  end
end

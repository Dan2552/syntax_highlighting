module SyntaxHighlighting
  class Theme
    # - parameter theme_data: Hash repesentation of a `sublime-color-scheme`
    #
    def initialize(theme_data)
      @name = theme_data["name"]
      @globals = ThemeGlobals.new(theme_data["globals"])

      theme_data["rules"].each do |rule_data|
        rule = ThemeRule.new(rule_data)
        rules << rule

        rule.scopes.each do |scope|
          scopes[scope] ||= []
          scopes[scope] << rule
        end
      end
    end

    attr_reader :name
    attr_reader :globals

    def rules
      @rules ||= []
    end

    def scopes
      @scopes ||= {}
    end
  end
end

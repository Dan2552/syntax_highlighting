module SyntaxHighlighting
  class ThemeRule
    def initialize(rule_data)
      @name = rule_data["name"]
      @scopes = rule_data["scope"].split(",").map(&:strip)
      @font_style = rule_data["font_style"]
      @foreground = rule_data["foreground"]
      @background = rule_data["background"]
    end

    attr_reader :name
    attr_reader :scopes
    attr_reader :font_style
    attr_reader :foreground
    attr_reader :background
  end
end

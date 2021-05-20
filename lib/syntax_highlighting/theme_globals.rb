module SyntaxHighlighting
  class ThemeGlobals
    def initialize(globals_data)
      @background = globals_data["background"]
      @foreground = globals_data["foreground"]
      @invisibles = globals_data["invisibles"]
      @caret = globals_data["caret"]
      @block_caret = globals_data["block_caret"]
      @line_highlight = globals_data["line_highlight"]
      @accent = globals_data["accent"]
      @popup_css = globals_data["popup_css"]
      @gutter = globals_data["gutter"]
      @gutter_foreground = globals_data["gutter_foreground"]
      @line_diff_width = globals_data["line_diff_width"]
      @line_diff_added = globals_data["line_diff_added"]
      @line_diff_modified = globals_data["line_diff_modified"]
      @line_diff_deleted = globals_data["line_diff_deleted"]
      @selection = globals_data["selection"]
      @selection_border = globals_data["selection_border"]
      @selection_border_width = globals_data["selection_border_width"]
      @inactive_selection = globals_data["inactive_selection"]
      @inactive_selection_foreground = globals_data["inactive_selection_foreground"]
      @selection_corner_style = globals_data["selection_corner_style"]
      @selection_corner_radius = globals_data["selection_corner_radius"]
      @highlight = globals_data["highlight"]
      @find_highlight = globals_data["find_highlight"]
      @find_highlight_foreground = globals_data["find_highlight_foreground"]
      @guide = globals_data["guide"]
      @active_guide = globals_data["active_guide"]
      @stack_guide = globals_data["stack_guide"]
      @shadow = globals_data["shadow"]
      @shadow_width = globals_data["shadow_width"]
    end

    attr_reader :background
    attr_reader :foreground
    attr_reader :invisibles
    attr_reader :caret
    attr_reader :block_caret
    attr_reader :line_highlight
    attr_reader :accent
    attr_reader :popup_css
    attr_reader :gutter
    attr_reader :gutter_foreground
    attr_reader :line_diff_width
    attr_reader :line_diff_added
    attr_reader :line_diff_modified
    attr_reader :line_diff_deleted
    attr_reader :selection
    attr_reader :selection_border
    attr_reader :selection_border_width
    attr_reader :inactive_selection
    attr_reader :inactive_selection_foreground
    attr_reader :selection_corner_style
    attr_reader :selection_corner_radius
    attr_reader :highlight
    attr_reader :find_highlight
    attr_reader :find_highlight_foreground
    attr_reader :guide
    attr_reader :active_guide
    attr_reader :stack_guide
    attr_reader :shadow
    attr_reader :shadow_width
  end
end

describe SyntaxHighlighting::ThemeApplicator do
  let(:theme) do
    SyntaxHighlighting::Theme.new(
      JSON.parse(
        File.read(
          Bundler.root.join(
            "resources",
            "syntax_highlighting",
            "themes",
            "ayu-light",
            "ayu-light.sublime-color-scheme"
          )
        )
      )
    )
  end
  let(:described_instance) { described_class.new(theme) }

  describe "#apply" do
    let(:line_of_text) do
      line = SyntaxHighlighting::LineOfText.new("def method(arg1, arg2)")

      line.character_metadata[0].find_or_create_reference(:"keyword.control.def.ruby")
      line.character_metadata[1].find_or_create_reference(:"keyword.control.def.ruby")
      line.character_metadata[2].find_or_create_reference(:"keyword.control.def.ruby")

      line.character_metadata[4].find_or_create_reference(:"entity.name.function.ruby")
      line.character_metadata[5].find_or_create_reference(:"entity.name.function.ruby")
      line.character_metadata[6].find_or_create_reference(:"entity.name.function.ruby")
      line.character_metadata[7].find_or_create_reference(:"entity.name.function.ruby")
      line.character_metadata[8].find_or_create_reference(:"entity.name.function.ruby")
      line.character_metadata[9].find_or_create_reference(:"entity.name.function.ruby")
      line.character_metadata[10].find_or_create_reference(:"punctuation.definition.parameters.ruby")
      line.character_metadata[11].find_or_create_reference(:"variable.parameter.function.ruby")
      line.character_metadata[12].find_or_create_reference(:"variable.parameter.function.ruby")
      line.character_metadata[13].find_or_create_reference(:"variable.parameter.function.ruby")
      line.character_metadata[14].find_or_create_reference(:"variable.parameter.function.ruby")
      line.character_metadata[15].find_or_create_reference(:"punctuation.separator.object.ruby")

      line.character_metadata[17].find_or_create_reference(:"variable.parameter.function.ruby")
      line.character_metadata[18].find_or_create_reference(:"variable.parameter.function.ruby")
      line.character_metadata[19].find_or_create_reference(:"variable.parameter.function.ruby")
      line.character_metadata[20].find_or_create_reference(:"variable.parameter.function.ruby")
      line.character_metadata[21].find_or_create_reference(:"punctuation.definition.parameters.ruby")

      line
    end

    subject { described_instance.apply(line_of_text) }

    it "applies theme rules" do
      subject
      scopes = line_of_text.character_metadata.map do |meta|
        meta.theme_rules&.first&.scopes&.first
      end

      expect(line_of_text.character_metadata.map(&:theme_rules).flatten.compact)
        .to all(be_a(SyntaxHighlighting::ThemeRule))

      expect(scopes).to eq([
        "keyword", # d
        "keyword", # e
        "keyword", # f
        nil,
        "entity.name.function", # m
        "entity.name.function", # e
        "entity.name.function", # t
        "entity.name.function", # h
        "entity.name.function", # o
        "entity.name.function", # d
        nil, # (
        "variable.parameter",  # a
        "variable.parameter", # r
        "variable.parameter", # g
        "variable.parameter", # 1
        "punctuation.separator", # ,
        nil,
        "variable.parameter", #a
        "variable.parameter", #r
        "variable.parameter", #g
        "variable.parameter", #2
        nil
       ])
    end
  end
end

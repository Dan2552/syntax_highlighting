shared_examples_for "a parsed line of text" do
  it "populates the line with metadata" do
    subject

    expect(subject).to inspect_like('
      <LineOfText
      "# hello"
      [
      <char 0  : # : :"comment.line.number-sign.ruby",:"punctuation.definition.comment.ruby">
      <char 1  :   : :"comment.line.number-sign.ruby">
      <char 2  : h : :"comment.line.number-sign.ruby">
      <char 3  : e : :"comment.line.number-sign.ruby">
      <char 4  : l : :"comment.line.number-sign.ruby">
      <char 5  : l : :"comment.line.number-sign.ruby">
      <char 6  : o : :"comment.line.number-sign.ruby">
      ]>
    ')
  end

  it "populates the line with styling" do
    scopes = subject.character_metadata.map do |meta|
      meta.theme_rules&.first&.scopes&.first
    end

    expect(subject.character_metadata.map(&:theme_rules).flatten.compact)
      .to all(be_a(SyntaxHighlighting::ThemeRule))

    expect(scopes).to eq(["comment", "comment", "comment", "comment", "comment", "comment", "comment"])
  end
end

describe SyntaxHighlighting::Highlighter do
  let(:config) { SyntaxHighlighting::Config.new }
  let(:described_instance) { described_class.new(config) }

  before do
    config.language_files = Dir.glob(
      Bundler.root.join(
        "resources",
        "syntax_highlighting",
        "**",
        "*.tmLanguage.json"
      )
    )
    config.theme_file = Bundler.root.join(
      "resources",
      "syntax_highlighting",
      "themes",
      "ayu-light",
      "ayu-light.sublime-color-scheme"
    )
  end

  describe "#parse" do
    let(:line_of_text) { SyntaxHighlighting::LineOfText.new("# hello") }
    let(:language_name) { :ruby }
    subject { described_instance.parse(line_of_text, language_name) }

    it_behaves_like "a parsed line of text"

    context "when using a string as the line of text" do
      let(:line_of_text) { "# hello" }

      it_behaves_like "a parsed line of text"
    end

    context "with a language that doesn't exist" do
      let(:language_name) { :banana }

      it "raises an error" do
        expect { subject }
          .to raise_error("language banana not found")
      end
    end
  end

  describe "#inspect" do
    subject { described_instance.inspect }

    it { is_expected.to be_a(String) }
  end
end

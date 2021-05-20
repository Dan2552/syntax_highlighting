describe SyntaxHighlighting::Repository do
  let(:contents) do
    JSON.parse(
      File.read(
        Bundler.root.join(
          "resources",
          "syntax_highlighting",
          "syntaxes",
          "ruby",
          "ruby.tmLanguage.json"
        )
      )
    )
  end
  let(:described_instance) { SyntaxHighlighting::Language.new(contents).repository }

  describe "#get" do
    subject { described_instance.get(key) }

    context "with a key that exists" do
      let(:key) { "#escaped_char" }

      it { is_expected.to be_a(SyntaxHighlighting::Pattern) }
    end

    context "with $self" do
      let(:key) { "$self" }

      it { is_expected.to be_a(SyntaxHighlighting::Language) }
    end

    context "with a key that doesn't exist" do
      let(:key) { "banana" }

      it { is_expected.to eq(nil) }
    end
  end

  describe "#keys" do
    subject { described_instance.keys }

    it { is_expected.to be_an(Array) }
    it { is_expected.to include("$self") }
    it { is_expected.to include("#escaped_char") }
  end
end

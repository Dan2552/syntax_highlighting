describe SyntaxHighlighting::Language do
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
  let(:described_instance) { described_class.new(contents) }

  describe "#name" do
    subject { described_instance.name }

    it { is_expected.to eq("Ruby") }
  end

  describe "#scope_name" do
    subject { described_instance.scope_name }

    it { is_expected.to eq("source.ruby") }
  end

  describe "#repository" do
    subject { described_instance.repository }

    it { is_expected.to be_a(SyntaxHighlighting::Repository) }
  end

  describe "#patterns" do
    subject { described_instance.patterns }

    it { is_expected.to be_a(Array) }
    it { is_expected.to all(be_a(SyntaxHighlighting::Pattern)) }

    it "all unwraps" do
      expect { _unwrap(described_instance) }
        .to_not raise_error
    end
  end
end

describe SyntaxHighlighting::Theme do
  let(:theme_data) do
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
  end

  let(:described_instance) { described_class.new(theme_data) }

  describe "#name" do
    subject { described_instance.name }

    it { is_expected.to eq("ayu") }
  end

  describe "#globals" do
    subject { described_instance.globals }

    it { is_expected.to be_a(SyntaxHighlighting::ThemeGlobals) }
  end

  describe "#rules" do
    subject { described_instance.rules }

    it { is_expected.to be_a(Array) }
    it { is_expected.to all(be_a(SyntaxHighlighting::ThemeRule)) }
  end

  describe "#scopes" do
    subject { described_instance.scopes }

    it { is_expected.to be_a(Hash) }

    it "finds a rule given a scope" do
      expect(subject["constant.other.symbol"]).to be_a(Array)
      expect(subject["constant.other.symbol"].count).to eq(1)
      expect(subject["constant.other.symbol"].first).to be_a(SyntaxHighlighting::ThemeRule)
    end
  end
end

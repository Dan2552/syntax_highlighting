describe SyntaxHighlighting::MultiLanguageRepository do
  let(:filepaths) do
    Dir.glob(Bundler.root.join("resources", "syntax_highlighting", "**", "*.tmLanguage.json"))
  end
  let(:described_instance) { described_class.new(filepaths) }

  describe "#get" do
    let(:key) { "source.ruby" }
    subject { described_instance.get(key) }

    it { is_expected.to be_a(SyntaxHighlighting::Language) }

    it "returns the matching language" do
      expect(subject.scope_name).to eq(key)
    end

    it "has the capability of searching for languages" do
      described_instance.keys.each do |other_language_key|
        expect(subject.repository.get(other_language_key)).to be_a(SyntaxHighlighting::Language)
      end
    end
  end

  describe "#keys" do
    subject { described_instance.keys }

    it { is_expected.to be_an(Array) }
    it { is_expected.to be_frozen }
    it { is_expected.to include("source.ruby") }
  end
end

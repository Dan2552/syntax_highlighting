describe SyntaxHighlighting do
  describe ".configure" do
    it "yields the config" do
      expect { |blk| described_class.configure(&blk) }.to yield_with_args(instance_of(SyntaxHighlighting::Config))
    end
  end

  describe ".config" do
    subject { described_class.config }

    it { is_expected.to be_a(SyntaxHighlighting::Config) }

    it "returns the same instance each call" do
      expect(subject).to eql(described_class.config)
    end
  end
end

describe SyntaxHighlighting::Config do
  let(:described_instance) { described_class.new }

  describe "#language_files" do
    subject { described_instance.language_files }

    it { is_expected.to eq(nil) }

    context "when set" do
      before do
        described_instance.language_files = "value"
      end

      it { is_expected.to eq("value") }
    end
  end

  describe "#theme_file" do
    subject { described_instance.theme_file }

    it { is_expected.to eq(nil) }

    context "when set" do
      before do
        described_instance.theme_file = "value"
      end

      it { is_expected.to eq("value") }
    end
  end
end

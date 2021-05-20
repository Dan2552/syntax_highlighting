describe SyntaxHighlighting::CharacterMetadata do
  let(:index) { 4 }
  let(:line_of_text) { SyntaxHighlighting::LineOfText.new("hello world") }
  let(:described_instance) { described_class.new(index, line_of_text) }

  describe "#index" do
    subject { described_instance.index }

    it { is_expected.to eq(index) }
  end

  describe "#find_or_create_reference" do
    let(:name) { "reference" }
    subject { described_instance.find_or_create_reference(name) }

    it "adds the reference" do
      expect { subject }
        .to change { described_instance.references }
        .from([])
        .to(["reference"])
    end

    context "when adding the same name again" do
      before do
        described_instance.find_or_create_reference(name)
      end

      it "doesn't change anything" do
        expect { subject }
          .to_not change { described_instance.references  }
      end
    end

    context "when adding a different name" do
      before do
        described_instance.find_or_create_reference("different")
      end

      it "adds that reference" do
        expect { subject }
          .to change { described_instance.references }
          .from(["different"])
          .to(["different", "reference"])
      end
    end

    context "#inspect" do
      subject { described_instance.inspect }

      it { is_expected.to be_a(String) }
    end

    context "#to_s" do
      subject { described_instance.to_s }

      it { is_expected.to be_a(String) }
    end
  end
end

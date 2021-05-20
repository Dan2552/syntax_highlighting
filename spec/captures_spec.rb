describe SyntaxHighlighting::Captures do
  let(:contents) do
    {
      "1" => {
        "name" => "keyword.control.def.ruby"
      },
      "2" => {
        "name" => "entity.name.function.ruby"
      },
      "3" => {
        "name" => "punctuation.definition.parameters.ruby"
      }
    }
  end
  let(:described_instance) { described_class.new(contents) }

  describe "#each" do
    let(:iterations) do
      []
    end

    let(:blk) do
      Proc.new do |key, value|
        iterations << [key, value]
      end
    end
    subject { described_instance.each(&blk) }

    it "iterates all values" do
      expect { subject }
        .to change { iterations }
        .from([])
        .to(
          [
            [1, :"keyword.control.def.ruby"],
            [2, :"entity.name.function.ruby"],
            [3, :"punctuation.definition.parameters.ruby"]
          ]
        )
    end
  end

  describe "#[]" do
    subject { described_instance[index] }

    context "with an index that has a value" do
      let(:index) { 2 }

      it "returns the name" do
        expect(subject).to eq(:"entity.name.function.ruby")
      end
    end

    context "with an index that doesn't have a value" do
      let(:index) { 4 }

      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end
  end

  describe "#inspect" do
    subject { described_instance.inspect }

    it { is_expected.to be_a(String) }
  end

  describe "#to_s" do
    subject { described_instance.to_s }

    it { is_expected.to be_a(String) }
  end
end

describe SyntaxHighlighting::Pattern do
  let(:contents) do
    {
      "begin" => "begin_value",
      "end" => "end_value",
      "beginCaptures" => { "0" => { "name" => "begin_captures_value" } },
      "endCaptures" => { "0" => { "name" => "end_captures_value" } },
      "contentName" => "content_name_value",
      "name" => "name_value",
      "captures" => { "0" => { "name" => "captures_value" } },
      "match" => "match_value",
      "repository" => {
        "banana" => {
          "name" => "banana_name_value"
        }
      }
    }
  end
  let(:described_instance) { SyntaxHighlighting::Pattern.new(contents) }

  describe ".find_or_initialize" do
    let(:repository) { double(:repository) }
    subject { described_class.find_or_initialize(contents, repository) }

    it { is_expected.to be_a(SyntaxHighlighting::Pattern) }

    it "initializes with the same arguments" do
      new_pattern = double(:new_pattern)

      expect(described_class)
        .to receive(:new)
        .with(contents, repository)
        .and_return(new_pattern)

      expect(subject).to eq(new_pattern)
    end

    context "when the pattern is a reference to another" do
      let(:contents) {
        {
          "include" => "banana"
        }
      }

      it "returns the pattern it references" do
        referenced_pattern = double(:referenced_pattern)

        expect(repository)
          .to receive(:get)
          .with("banana")
          .and_return(referenced_pattern)

        expect(subject).to eq(referenced_pattern)
      end
    end
  end

  describe "#begin" do
    subject { described_instance.begin }

    it { is_expected.to eq(/begin_value/) }
  end

  describe "#end" do
    subject { described_instance.end }

    it { is_expected.to eq(/end_value/) }
  end

  describe "#begin_captures" do
    subject { described_instance.begin_captures }

    it { is_expected.to be_a(SyntaxHighlighting::Captures) }

    it "contains the captures" do
      expect(subject[0]).to eq(:begin_captures_value)
    end
  end

  describe "#end_captures" do
    subject { described_instance.end_captures }

    it { is_expected.to be_a(SyntaxHighlighting::Captures) }

    it "contains the captures" do
      expect(subject[0]).to eq(:end_captures_value)
    end
  end

  describe "#content_name" do
    subject { described_instance.content_name }

    it { is_expected.to eq("content_name_value") }
  end

  describe "#name" do
    subject { described_instance.name }

    it { is_expected.to eq(:name_value) }
  end

  describe "#captures" do
    subject { described_instance.captures }

    it { is_expected.to be_a(SyntaxHighlighting::Captures) }

    it "contains the captures" do
      expect(subject[0]).to eq(:captures_value)
    end
  end

  describe "#match" do
    subject { described_instance.match }

    it { is_expected.to eq(/match_value/) }
  end

  describe "#repository" do
    subject { described_instance.repository }

    it { is_expected.to be_a(SyntaxHighlighting::Repository) }

    it "contains the child patterns" do
      expect(subject.get("#banana")).to be_a(SyntaxHighlighting::Pattern)
      expect(subject.get("#banana").name).to eq(:banana_name_value)
    end
  end

  describe "#inspect" do
    subject { described_instance.inspect }

    it { is_expected.to be_a(String) }
  end

  describe "#patterns" do
    subject { described_instance.patterns }

    # Seems some languages should support children on `match` too, but for now
    # is unhandled.
    context "on a pattern that can have children" do
      before do
        contents.delete("match")
        contents["patterns"] = [
          { "name" => "child1" },
          { "name" => "child2" }
        ]
      end

      it { is_expected.to be_an(Array) }
      it { is_expected.to all(be_a(SyntaxHighlighting::Pattern)) }
    end
  end
end

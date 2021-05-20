describe SyntaxHighlighting::LineOfText do
  let(:text) do
    "def method(arg1, arg2)"
  end

  let(:described_instance) { described_class.new(text) }

  describe ".build" do
    subject { described_class.build(text) }

    context "with a single line of text" do
      let(:text) do
        "def method(arg1, arg2)"
      end

      it { is_expected.to be_a(SyntaxHighlighting::LineOfText) }

      it "has a no next line of text" do
        expect(subject.next_line).to eq(nil)
      end

      it "has a no previous line of text" do
        expect(subject.previous_line).to eq(nil)
      end
    end

    context "with a multiple line of text" do
      let(:text) do
        "def method(arg1, arg2)\n" +
        "  puts 'hello world'\n" +
        "end"
      end

      it { is_expected.to be_a(SyntaxHighlighting::LineOfText) }

      it "has a no previous line of text" do
        expect(subject.previous_line).to eq(nil)
      end

      it "has 2 following next line of text" do
        line0 = subject
        line1 = line0.next_line
        line2 = line1.next_line
        line3 = line2.next_line

        expect(line1).to be_a(SyntaxHighlighting::LineOfText)
        expect(line2).to be_a(SyntaxHighlighting::LineOfText)
        expect(line3).to eq(nil)
      end
    end
  end

  describe "#length" do
    subject { described_instance.length }

    it { is_expected.to eq(text.length) }
  end

  describe "#next_line" do
    subject { described_instance.next_line }

    context "without having one set" do
      it { is_expected.to eq(nil) }
    end
  end

  describe "#previous_line" do
    subject { described_instance.previous_line }

    context "without having one set" do
      it { is_expected.to eq(nil) }
    end
  end

  describe "#character_metadata" do
    subject { described_instance.character_metadata }

    it { is_expected.to be_an(Array) }
    it { is_expected.to be_frozen }
  end

  describe "#match" do
    let(:regex) { /arg/ }
    subject { described_instance.match(regex) }

    it { is_expected.to be_a(MatchData) }
  end

  describe "#matches" do
    let(:regex) { /arg/ }
    subject { described_instance.matches(regex) }

    it { is_expected.to be_an(Array) }
    it { is_expected.to all(be_a(MatchData)) }

    it "returns different matches" do
      expect(subject[0].offset(0)).to eq([11, 14])
      expect(subject[1].offset(0)).to eq([17, 20])
    end
  end

  describe "#to_s" do
    subject { described_instance.to_s }

    it { is_expected.to be_a(String) }
  end

  describe "#inspect" do
    subject { described_instance.inspect }

    it { is_expected.to be_a(String) }
  end

  describe "#previous_line=" do
    let(:previous_line) { SyntaxHighlighting::LineOfText.new("previous line") }
    subject { described_instance.previous_line = previous_line }

    it "sets the previous line" do
      expect { subject }
        .to change { described_instance.previous_line }
        .from(nil)
        .to(previous_line)
    end

    it "sets the next line for the previous line" do
      expect { subject }
        .to change { previous_line.next_line }
        .from(nil)
        .to(described_instance)
    end
  end

  describe "#next_line=" do
    let(:next_line) { SyntaxHighlighting::LineOfText.new("next line") }
    subject { described_instance.next_line = next_line }

    it "sets the next line" do
      expect { subject }
        .to change { described_instance.next_line }
        .from(nil)
        .to(next_line)
    end

    it "sets the previous line for the next line" do
      expect { subject }
        .to change { next_line.previous_line }
        .from(nil)
        .to(described_instance)
    end
  end

  describe "#previous_line_without_next_line_ref=" do
    let(:previous_line) { SyntaxHighlighting::LineOfText.new("previous line") }
    subject { described_instance.previous_line_without_next_line_ref = previous_line }

    it "sets the previous line" do
      expect { subject }
        .to change { described_instance.previous_line }
        .from(nil)
        .to(previous_line)
    end

    it "does not set the next line for the previous line" do
      expect { subject }
        .to_not change { previous_line.next_line }
    end
  end

  describe "#next_line_without_next_line_ref=" do
    let(:next_line) { SyntaxHighlighting::LineOfText.new("next line") }
    subject { described_instance.next_line_without_next_line_ref = next_line }

    it "sets the next line" do
      expect { subject }
        .to change { described_instance.next_line }
        .from(nil)
        .to(next_line)
    end

    it "does not set the previous line for the next line" do
      expect { subject }
        .to_not change { next_line.previous_line }
    end
  end
end

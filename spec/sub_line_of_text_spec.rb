describe SyntaxHighlighting::SubLineOfText do
  let(:line_of_text) { SyntaxHighlighting::LineOfText.new('hello = "hello world"') }
  let(:start_index) { 8 }
  let(:end_index) { -1 }
  let(:described_instance) { described_class.new(line_of_text, start_index, end_index) }

  describe "#to_s" do
    subject { described_instance.to_s }

    it "returns the substring" do
      expect(subject).to eq('"hello world"')
    end
  end

  describe "#character_metadata" do
    subject { described_instance.character_metadata }

    it "returns the sub section of character_metadata of the parent" do
      expect(subject.count).to eq(13)
      expect(subject).to eq(line_of_text.character_metadata[start_index..end_index])
    end
  end

  describe "#inspect" do
    subject { described_instance.inspect }

    it { is_expected.to be_a(String) }
  end

  describe "#match" do
    let(:regex) { /o/ }
    subject { described_instance.match(regex) }

    it { is_expected.to be_a(MatchData) }
  end

  describe "#matches" do
    let(:regex) { /o/ }
    subject { described_instance.matches(regex) }

    it { is_expected.to be_an(Array) }
    it { is_expected.to all(be_a(MatchData)) }

    it "returns different matches" do
      expect(subject[0].offset(0)).to eq([5, 6])
      expect(subject[1].offset(0)).to eq([8, 9])
    end
  end

  describe "#length" do
    subject { described_instance.length }

    it { is_expected.to eq('"hello world"'.length) }
  end

  describe "#next_line" do
    subject { described_instance.next_line }

    it { is_expected.to eq(nil) }

    context "original line of text has a next_line" do
      let(:next_line) { SyntaxHighlighting::LineOfText.new("next line") }

      before do
        line_of_text.next_line = next_line
      end

      context "when the subline goes up to the last character" do
        let(:end_index) { -1 }

        it { is_expected.to eq(next_line) }

        context "with a postive integer" do
          let(:end_index) { 20 }

          it { is_expected.to eq(next_line) }
        end
      end

      context "when the subline doesn't go to the last character" do
        let(:end_index) { 19 }

        it { is_expected.to eq(nil) }
      end
    end
  end
end

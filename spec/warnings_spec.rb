class WarningsTest
  include SyntaxHighlighting::Warnings
end

describe SyntaxHighlighting::Warnings do
  let(:described_instance) { WarningsTest.new }

  describe "#silence_warnings" do
    it "sets verbose to nil during the yield" do
      yielded = false
      expect($VERBOSE).to_not eq(nil)
      described_instance.silence_warnings do
        yielded = true
        expect($VERBOSE).to eq(nil)
      end
      expect($VERBOSE).to_not eq(nil)
      expect(yielded).to eq(true)
    end
  end
end

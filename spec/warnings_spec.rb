describe SyntaxHighlighting::Warnings do
  describe "#silence" do
    it "sets verbose to nil during the yield" do
      yielded = false
      expect($VERBOSE).to_not eq(nil)
      described_class.silence do
        yielded = true
        expect($VERBOSE).to eq(nil)
      end
      expect($VERBOSE).to_not eq(nil)
      expect(yielded).to eq(true)
    end
  end
end

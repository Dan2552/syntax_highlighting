describe SyntaxHighlighting::Parser do
  let(:language) do
    SyntaxHighlighting::Language.new(
      JSON.parse(
        File.read(
          Bundler.root.join(
            "resources",
            "syntax_highlighting",
            "syntaxes",
            "ruby",
            "ruby.tmLanguage.json"
          )
        )
      )
    )
  end

  let(:described_instance) { described_class.new(language) }

  describe "#pattern_names_for_line" do

    subject { described_instance.pattern_names_for_line(line_of_text) }

    context "single line of text" do
      let(:line_of_text) { SyntaxHighlighting::LineOfText.new("def method(arg1)") }

      it "tags characters on the line" do
        subject

        expect(line_of_text).to inspect_like('
          <LineOfText
          "def method(arg1)"
          [
          <char 0  : d : :"meta.function.method.with-arguments.ruby",:"keyword.control.def.ruby">
          <char 1  : e : :"meta.function.method.with-arguments.ruby",:"keyword.control.def.ruby">
          <char 2  : f : :"meta.function.method.with-arguments.ruby",:"keyword.control.def.ruby">
          <char 3  :   : :"meta.function.method.with-arguments.ruby">
          <char 4  : m : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 5  : e : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 6  : t : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 7  : h : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 8  : o : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 9  : d : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 10 : ( : :"meta.function.method.with-arguments.ruby",:"punctuation.definition.parameters.ruby">
          <char 11 : a : :"variable.parameter.function.ruby">
          <char 12 : r : :"variable.parameter.function.ruby">
          <char 13 : g : :"variable.parameter.function.ruby">
          <char 14 : 1 : :"variable.parameter.function.ruby">
          <char 15 : ) : :"meta.function.method.with-arguments.ruby",:"punctuation.definition.parameters.ruby">
          ]>
        ')
      end
    end

    context "multiple line of text" do
      let(:line_of_text) do
        text =
          "def method(arg1, arg2)\n" +
          "  puts 'hello world'\n" +
          "end\n" +
          "def method2\n" +
          "end\n"

        SyntaxHighlighting::LineOfText.build(text)
      end

      it "only tags the first line" do
        subject

        line0 = line_of_text
        line1 = line0.next_line
        line2 = line1.next_line
        line3 = line2.next_line

        expect(line0).to inspect_like('
          <LineOfText
          "def method(arg1, arg2)\n"
          [
          <char 0  : d : :"meta.function.method.with-arguments.ruby",:"keyword.control.def.ruby">
          <char 1  : e : :"meta.function.method.with-arguments.ruby",:"keyword.control.def.ruby">
          <char 2  : f : :"meta.function.method.with-arguments.ruby",:"keyword.control.def.ruby">
          <char 3  :   : :"meta.function.method.with-arguments.ruby">
          <char 4  : m : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 5  : e : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 6  : t : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 7  : h : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 8  : o : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 9  : d : :"meta.function.method.with-arguments.ruby",:"entity.name.function.ruby">
          <char 10 : ( : :"meta.function.method.with-arguments.ruby",:"punctuation.definition.parameters.ruby">
          <char 11 : a : :"variable.parameter.function.ruby">
          <char 12 : r : :"variable.parameter.function.ruby">
          <char 13 : g : :"variable.parameter.function.ruby">
          <char 14 : 1 : :"variable.parameter.function.ruby">
          <char 15 : , : :"punctuation.separator.object.ruby">
          <char 16 :   : >
          <char 17 : a : :"variable.parameter.function.ruby">
          <char 18 : r : :"variable.parameter.function.ruby">
          <char 19 : g : :"variable.parameter.function.ruby">
          <char 20 : 2 : :"variable.parameter.function.ruby">
          <char 21 : ) : :"meta.function.method.with-arguments.ruby",:"punctuation.definition.parameters.ruby">
          <char 22 :
          : >
          ]>
        ')

        expect(line1).to inspect_like("
          <LineOfText
          \"  puts 'hello world'\\n\"
          [
          <char 0  :   : >
          <char 1  :   : >
          <char 2  : p : >
          <char 3  : u : >
          <char 4  : t : >
          <char 5  : s : >
          <char 6  :   : >
          <char 7  : ' : >
          <char 8  : h : >
          <char 9  : e : >
          <char 10 : l : >
          <char 11 : l : >
          <char 12 : o : >
          <char 13 :   : >
          <char 14 : w : >
          <char 15 : o : >
          <char 16 : r : >
          <char 17 : l : >
          <char 18 : d : >
          <char 19 : ' : >
          <char 20 :
          : >
          ]>
        ")

        expect(line2).to inspect_like('
          <LineOfText
          "end\n"
          [
          <char 0  : e : >
          <char 1  : n : >
          <char 2  : d : >
          <char 3  :
          : >
          ]>
        ')
      end
    end

    context "single line with strings" do
      let(:line_of_text) do
        text = "my_string = \"hello \" + \"world\""
        SyntaxHighlighting::LineOfText.build(text)
      end

      it "tags characters on the line" do
        subject

        expect(line_of_text).to inspect_like('
          <LineOfText
          "my_string = \"hello \" + \"world\""
          [
          <char 0  : m : >
          <char 1  : y : >
          <char 2  : _ : >
          <char 3  : s : >
          <char 4  : t : >
          <char 5  : r : >
          <char 6  : i : >
          <char 7  : n : >
          <char 8  : g : >
          <char 9  :   : >
          <char 10 : = : :"keyword.operator.assignment.ruby">
          <char 11 :   : >
          <char 12 : " : :"string.quoted.double.ruby",:"punctuation.definition.string.begin.ruby">
          <char 13 : h : :"string.quoted.double.ruby">
          <char 14 : e : :"string.quoted.double.ruby">
          <char 15 : l : :"string.quoted.double.ruby">
          <char 16 : l : :"string.quoted.double.ruby">
          <char 17 : o : :"string.quoted.double.ruby">
          <char 18 :   : :"string.quoted.double.ruby">
          <char 19 : " : :"string.quoted.double.ruby",:"punctuation.definition.string.end.ruby">
          <char 20 :   : >
          <char 21 : + : :"keyword.operator.arithmetic.ruby">
          <char 22 :   : >
          <char 23 : " : :"string.quoted.double.ruby",:"punctuation.definition.string.begin.ruby">
          <char 24 : w : :"string.quoted.double.ruby">
          <char 25 : o : :"string.quoted.double.ruby">
          <char 26 : r : :"string.quoted.double.ruby">
          <char 27 : l : :"string.quoted.double.ruby">
          <char 28 : d : :"string.quoted.double.ruby">
          <char 29 : " : :"string.quoted.double.ruby",:"punctuation.definition.string.end.ruby">
          ]>
        ')
      end
    end

    context "multiple lines with string" do
      let(:line_of_text) do
        text = "my_string = \"hello\nworld\""
        SyntaxHighlighting::LineOfText.build(text)
      end

      it "tags characters on the lines up to the end of the string" do
        subject

        line0 = line_of_text
        line1 = line0.next_line
        line2 = line1.next_line

        expect(line0).to inspect_like('
          <LineOfText
          "my_string = \"hello\n"
          [
          <char 0  : m : >
          <char 1  : y : >
          <char 2  : _ : >
          <char 3  : s : >
          <char 4  : t : >
          <char 5  : r : >
          <char 6  : i : >
          <char 7  : n : >
          <char 8  : g : >
          <char 9  :   : >
          <char 10 : = : :"keyword.operator.assignment.ruby">
          <char 11 :   : >
          <char 12 : " : :"string.quoted.double.ruby",:"punctuation.definition.string.begin.ruby">
          <char 13 : h : :"string.quoted.double.ruby">
          <char 14 : e : :"string.quoted.double.ruby">
          <char 15 : l : :"string.quoted.double.ruby">
          <char 16 : l : :"string.quoted.double.ruby">
          <char 17 : o : :"string.quoted.double.ruby">
          <char 18 :
          : >
          ]>
        ')

        expect(line1).to inspect_like('
          <LineOfText
          "world\""
          [
          <char 0  : w : :"string.quoted.double.ruby">
          <char 1  : o : :"string.quoted.double.ruby">
          <char 2  : r : :"string.quoted.double.ruby">
          <char 3  : l : :"string.quoted.double.ruby">
          <char 4  : d : :"string.quoted.double.ruby">
          <char 5  : " : :"string.quoted.double.ruby",:"punctuation.definition.string.end.ruby">
          ]>
        ')

        expect(line2).to eq(nil)
      end
    end

    context "numbers in strings" do
      let(:line_of_text) do
        text = '"123"'
        SyntaxHighlighting::LineOfText.build(text)
      end

      it "doesn't count the numbers inside as ruby" do
        subject

        expect(line_of_text).to inspect_like('
          <LineOfText
          "\"123\""
          [
          <char 0  : " : :"string.quoted.double.ruby",:"punctuation.definition.string.begin.ruby">
          <char 1  : 1 : :"string.quoted.double.ruby">
          <char 2  : 2 : :"string.quoted.double.ruby">
          <char 3  : 3 : :"string.quoted.double.ruby">
          <char 4  : " : :"string.quoted.double.ruby",:"punctuation.definition.string.end.ruby">
          ]>
        ')
      end
    end

    context "interpolation" do
      let(:line_of_text) do
        text = 'a = "#{1 + 2}"'
        SyntaxHighlighting::LineOfText.build(text)
      end

      it "tags characters on the line" do
        subject

        expect(line_of_text).to inspect_like('
          <LineOfText
          "a = \"\#{1 + 2}\""
          [
          <char 0  : a : >
          <char 1  :   : >
          <char 2  : = : :"keyword.operator.assignment.ruby">
          <char 3  :   : >
          <char 4  : " : :"string.quoted.double.ruby",:"punctuation.definition.string.begin.ruby">
          <char 5  : # : :"meta.embedded.line.ruby",:"punctuation.section.embedded.begin.ruby">
          <char 6  : { : :"meta.embedded.line.ruby",:"punctuation.section.embedded.begin.ruby">
          <char 7  : 1 : :"meta.embedded.line.ruby",:"constant.numeric.integer.ruby">
          <char 8  :   : :"meta.embedded.line.ruby">
          <char 9  : + : :"meta.embedded.line.ruby",:"keyword.operator.arithmetic.ruby">
          <char 10 :   : :"meta.embedded.line.ruby">
          <char 11 : 2 : :"meta.embedded.line.ruby",:"constant.numeric.integer.ruby">
          <char 12 : } : :"meta.embedded.line.ruby",:"punctuation.section.embedded.end.ruby",:"source.ruby">
          <char 13 : " : :"string.quoted.double.ruby",:"punctuation.definition.string.end.ruby">
          ]>
       ')
      end
    end

    context "comment" do
      let(:line_of_text) do
        text = "# Load the game (the files we're testing)"
        SyntaxHighlighting::LineOfText.build(text)
      end

      it "counts the whole line as a comment" do
        subject

        expect(line_of_text).to inspect_like('
          <LineOfText
          "# Load the game (the files we\'re testing)"
          [
          <char 0  : # : :"comment.line.number-sign.ruby",:"punctuation.definition.comment.ruby">
          <char 1  :   : :"comment.line.number-sign.ruby">
          <char 2  : L : :"comment.line.number-sign.ruby">
          <char 3  : o : :"comment.line.number-sign.ruby">
          <char 4  : a : :"comment.line.number-sign.ruby">
          <char 5  : d : :"comment.line.number-sign.ruby">
          <char 6  :   : :"comment.line.number-sign.ruby">
          <char 7  : t : :"comment.line.number-sign.ruby">
          <char 8  : h : :"comment.line.number-sign.ruby">
          <char 9  : e : :"comment.line.number-sign.ruby">
          <char 10 :   : :"comment.line.number-sign.ruby">
          <char 11 : g : :"comment.line.number-sign.ruby">
          <char 12 : a : :"comment.line.number-sign.ruby">
          <char 13 : m : :"comment.line.number-sign.ruby">
          <char 14 : e : :"comment.line.number-sign.ruby">
          <char 15 :   : :"comment.line.number-sign.ruby">
          <char 16 : ( : :"comment.line.number-sign.ruby">
          <char 17 : t : :"comment.line.number-sign.ruby">
          <char 18 : h : :"comment.line.number-sign.ruby">
          <char 19 : e : :"comment.line.number-sign.ruby">
          <char 20 :   : :"comment.line.number-sign.ruby">
          <char 21 : f : :"comment.line.number-sign.ruby">
          <char 22 : i : :"comment.line.number-sign.ruby">
          <char 23 : l : :"comment.line.number-sign.ruby">
          <char 24 : e : :"comment.line.number-sign.ruby">
          <char 25 : s : :"comment.line.number-sign.ruby">
          <char 26 :   : :"comment.line.number-sign.ruby">
          <char 27 : w : :"comment.line.number-sign.ruby">
          <char 28 : e : :"comment.line.number-sign.ruby">
          <char 29 : \' : :"comment.line.number-sign.ruby">
          <char 30 : r : :"comment.line.number-sign.ruby">
          <char 31 : e : :"comment.line.number-sign.ruby">
          <char 32 :   : :"comment.line.number-sign.ruby">
          <char 33 : t : :"comment.line.number-sign.ruby">
          <char 34 : e : :"comment.line.number-sign.ruby">
          <char 35 : s : :"comment.line.number-sign.ruby">
          <char 36 : t : :"comment.line.number-sign.ruby">
          <char 37 : i : :"comment.line.number-sign.ruby">
          <char 38 : n : :"comment.line.number-sign.ruby">
          <char 39 : g : :"comment.line.number-sign.ruby">
          <char 40 : ) : :"comment.line.number-sign.ruby">
          ]>
        ')
      end
    end

    context "block params" do
      let(:line_of_text) do
        text = "RSpec.configure do |config|"
        SyntaxHighlighting::LineOfText.build(text)
      end

      it "counts the whole line as a comment" do
        subject

        expect(line_of_text).to inspect_like('
          <LineOfText
          "RSpec.configure do |config|"
          [
          <char 0  : R : :"support.class.ruby",:"variable.other.constant.ruby">
          <char 1  : S : :"support.class.ruby",:"variable.other.constant.ruby">
          <char 2  : p : :"support.class.ruby",:"variable.other.constant.ruby">
          <char 3  : e : :"support.class.ruby",:"variable.other.constant.ruby">
          <char 4  : c : :"support.class.ruby",:"variable.other.constant.ruby">
          <char 5  : . : :"punctuation.separator.method.ruby">
          <char 6  : c : >
          <char 7  : o : >
          <char 8  : n : >
          <char 9  : f : >
          <char 10 : i : >
          <char 11 : g : >
          <char 12 : u : >
          <char 13 : r : >
          <char 14 : e : >
          <char 15 :   : >
          <char 16 : d : :"keyword.control.start-block.ruby">
          <char 17 : o : :"keyword.control.start-block.ruby">
          <char 18 :   : >
          <char 19 : | : :"punctuation.separator.arguments.ruby">
          <char 20 : c : :"variable.other.block.ruby">
          <char 21 : o : :"variable.other.block.ruby">
          <char 22 : n : :"variable.other.block.ruby">
          <char 23 : f : :"variable.other.block.ruby">
          <char 24 : i : :"variable.other.block.ruby">
          <char 25 : g : :"variable.other.block.ruby">
          <char 26 : | : :"punctuation.separator.arguments.ruby">
          ]>
        ')
      end
    end
  end
end

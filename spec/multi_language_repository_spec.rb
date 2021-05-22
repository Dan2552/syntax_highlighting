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

    [
      "text.html.cshtml",
      "source.shaderlab",
      "source.dockerfile",
      "source.go",
      "source.regexp.python",
      "source.python",
      "source.css",
      "source.clojure",
      "source.css.less",
      "source.css.scss",
      "source.sassdoc",
      "source.perl.6",
      "source.perl",
      "source.rust",
      "text.pug",
      "source.fsharp",
      "source.r",
      "source.java",
      "text.html.derivative",
      "text.html.basic",
      "source.php",
      "text.html.php",
      "source.lua",
      "text.xml",
      "text.xml.xsl",
      "source.asp.vb.net",
      "source.powershell",
      "documentation.injection.js.jsx",
      "source.ts",
      "source.tsx",
      "documentation.injection.ts",
      "source.ini",
      "source.json.comments",
      "source.json",
      "text.html.handlebars",
      "source.c.platform",
      "source.c",
      "source.cpp.embedded.macro",
      "source.cpp",
      "source.cuda-cpp",
      "source.swift",
      "source.makefile",
      "source.shell",
      "text.html.markdown",
      "source.yaml",
      "text.log",
      "source.cs",
      "source.julia",
      "source.batchfile",
      "source.groovy",
      "source.coffee",
      "source.js",
      "source.js.jsx",
      "source.hlsl",
      "source.objc",
      "source.objcpp",
      "source.ruby",
      "text.git-rebase",
      "text.git-commit",
      "source.ignore",
      "source.diff",
      "text.searchResult",
      "source.sql"
    ].each do |other_language_key|
      it "has the capability of loading the #{other_language_key} language" do
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

Gem::Specification.new do |spec|
  root = File.expand_path('..', __FILE__)
  require File.join(root, "lib", "syntax_highlighting", "version.rb").to_s

  spec.name = "syntax_highlighting"
  spec.version = SyntaxHighlighting::VERSION
  spec.authors = ["Daniel Inkpen"]
  spec.email = ["dan2552@gmail.com"]

  spec.summary = "Text syntax highlighting"
  spec.description = "Ruby implementation of tmLanguage + sublime-color-scheme syntax highlighting"
  spec.homepage = "https://github.com/Dan2552/syntax_highlighting"
  spec.license = "MIT"

  spec.files = Dir
    .glob(File.join(root, "**", "*.rb"))
    .reject { |f| f.match(%r{^(test|spec|features)/}) }

  if File.directory?(File.join(root, "exe"))
    spec.bindir = "exe"
    spec.executables = Dir.glob(File.join(root, "exe", "*")).map { |f| File.basename(f) }
  end

  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
end

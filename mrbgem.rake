MRuby::Gem::Specification.new("mruby-syntax_highlighting") do |spec|
  spec.license = "MIT"
  spec.authors = "Daniel Inkpen"
  spec.rbfiles = Dir.glob(File.join(__dir__, "lib", "syntax_highlighting", "**", "*.rb"))

  spec.add_dependency("mruby-dir-glob")
  spec.add_dependency("mruby-onig-regexp")
  spec.add_dependency("mruby-json")
end

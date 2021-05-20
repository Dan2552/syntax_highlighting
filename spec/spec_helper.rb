require "syntax_highlighting"

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.filter_run_when_matching :focus
end

RSpec::Matchers.define :inspect_like do |expected|
  match do |actual|
    actual.inspect.split("\n").map(&:strip).join("\n").strip == expected.split("\n").map(&:strip).join("\n").strip
  end

  failure_message do |actual|
    "expected inspect: \n" +
    expected.split("\n").map(&:strip).join("\n").strip +
    "\n\nactual inspect: \n" +
    actual.inspect.split("\n").map(&:strip).join("\n").strip
  end
end

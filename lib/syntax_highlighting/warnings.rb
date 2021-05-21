module SyntaxHighlighting
  module Warnings
    ENABLED = false

    def self.silence(&blk)
      original = $VERBOSE
      $VERBOSE = nil
      blk.call
    ensure
      $VERBOSE = original
    end

    def self.warn(message)
      return unless ENABLED
      STDERR.puts(message)
    end
  end
end

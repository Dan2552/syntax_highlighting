module SyntaxHighlighting
  module Warnings
    def self.silence(&blk)
      original = $VERBOSE
      $VERBOSE = nil
      blk.call
    ensure
      $VERBOSE = original
    end
  end
end

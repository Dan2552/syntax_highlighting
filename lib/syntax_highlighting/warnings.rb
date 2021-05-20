module SyntaxHighlighting
  module Warnings
    def silence_warnings(&blk)
      original = $VERBOSE
      $VERBOSE = nil
      blk.call
    ensure
      $VERBOSE = original
    end
  end
end

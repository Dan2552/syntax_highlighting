module SyntaxHighlighting
  class Config
    attr_accessor :language_files
    attr_accessor :theme_file
  end

  def self.configure(&blk)
    yield(config)
  end

  def self.config
    @config ||= Config.new
  end
end

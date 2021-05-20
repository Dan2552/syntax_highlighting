module SyntaxHighlighting
  class MultiLanguageRepository
    def initialize(filepaths)
      filepaths.each do |filepath|
        contents = JSON.parse(File.read(filepath))
        scope_name = contents["scopeName"]
        filepaths_store[scope_name] = filepath
      end

      @keys = filepaths_store.keys.dup.freeze
    end

    attr_reader :keys

    def get(key)
      return nil unless keys.include?(key)

      # Lazily get and store the language, as they can reference each other, to
      # help make load order independant.
      store[key] ||= begin
        filepath = filepaths_store[key]
        contents = JSON.parse(File.read(filepath))
        Language.new(contents, self)
      end
    end

    private

    def store
      @store ||= {}
    end

    def filepaths_store
      @filepaths_store ||= {}
    end
  end
end

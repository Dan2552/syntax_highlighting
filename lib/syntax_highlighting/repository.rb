module SyntaxHighlighting
  # A child object to `Language`; repesenting a repository from a tmLanguage
  # file.
  #
  class Repository
    # - parameter contents: Hash
    # - parameter parent: Repository
    #
    def initialize(contents, parent)
      contents.each do |name, pattern_contents|
        key = name.start_with?("$") ? name : "##{name}"
        if pattern_contents.is_a?(Pattern)
          store[key] = pattern_contents
        else
          store[key] = Pattern.find_or_initialize(pattern_contents, self)
        end
      end

      @parent = parent
    end

    # - returns: Pattern
    #
    def get(key)
      store[key] || (parent && parent.get(key))
    end

    # - returns: [String]
    #
    def keys
      store.keys + ((parent && parent.keys) || [])
    end

    private

    attr_reader :parent

    def store
      @store ||= {}
    end
  end
end

module SyntaxHighlighting
  # Represents a tmLanguage file.
  #
  class Language
    # - parameter contents: Hash
    #
    def initialize(contents, parent_repository = nil)
      @name = contents["name"]
      @scope_name = contents["scopeName"]

      @repository = Repository.new(
        { "$self" => self }.merge(contents["repository"] || {}),
        parent_repository
      )

      contents["patterns"].each do |pattern_contents|
        patterns << Pattern.find_or_initialize(pattern_contents, repository)
      end

      repository.freeze
      patterns.freeze
    end

    # The name of the language.
    #
    attr_reader :name

    # This is used as a reference when patterns need to reference another
    # language. E.g. in markdown, if you put a code block, the code inside can
    # be syntax highlighted to the type of code inside that block.
    #
    attr_reader :scope_name

    # Hash that stores reusable patterns that can be "included" in patterns.
    #
    # For example in the tmLanguage:
    # ```
    # "escaped_char": {
    #   "match": "\\\\(?:[0-7]{1,3}|x[\\da-fA-F]{1,2}|.)",
    #   "name": "constant.character.escape.ruby"
    # },
    # ```
    #
    # Is repesented here as `{ name => pattern }`
    #
    attr_reader :repository

    # See `Pattern`.
    #
    def patterns
      @patterns ||= []
    end

    def begin
      nil
    end

    def match
      nil
    end
  end
end

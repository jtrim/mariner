module Mariner

  module Errors

    # Private: This error is raised when Url tries to use a route helper
    # method that's unavailable or undefined
    #
    class InvalidUrlHelperMethod < RuntimeError
      attr_accessor :name

      def initialize(name)
        self.name = name
      end

      def message
        "Unknown url helper method used in navigation configuration: #{name.inspect}"
      end

      def to_s
        message
      end
    end

  end

end

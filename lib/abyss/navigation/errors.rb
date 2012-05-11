module Abyss

  module Errors

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

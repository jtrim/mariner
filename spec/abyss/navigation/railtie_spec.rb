require 'spec_helper'

module Abyss

  module Navigation

    describe Railtie do

      it "mixes the Rails routes helper into Url" do
        Url.new(nil, nil).should respond_to :root_path
      end

      it "mixes Helper into ActionController helpers" do
        ActionController::Base.ancestors.should include ::Abyss::Navigation::Helper
      end

    end

  end

end

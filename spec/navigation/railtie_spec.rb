require 'spec_helper'

module Mariner

  describe Railtie do

    it "mixes the Rails routes helper into Url" do
      Url.new(nil, nil).should respond_to :root_path
    end

    it "mixes Helper into ActionController helpers" do
      ActionController::Base.ancestors.should include ::Mariner::Helper
    end

  end

end

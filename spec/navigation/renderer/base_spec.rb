require 'spec_helper'

module Mariner

  module Renderer

    describe Base do

      describe "#initialize" do

        let(:fake_renderer) { stub(UnorderedListRenderer) }
        let(:fake_entity)   { stub }

        subject { Base.new(fake_entity, fake_renderer) }

        its(:subject)            { should == fake_entity }
        its(:rendering_strategy) { should == fake_renderer }

      end

    end

  end

end

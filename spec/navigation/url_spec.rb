require 'spec_helper'

module Mariner

  describe Url do

    subject { Url.new(:foo_path, "Thing", {:option => 'bar'}) }

    describe "#initialize" do

      its(:name)         { should == :foo_path }
      its(:title)        { should == "Thing" }
      its(:options)      { should == {:option => 'bar'} }

    end

    describe "#render" do

      let(:renderer_stub) { stub }

      context "by default" do

        it "uses a default rendering strategy" do
          UnorderedListRenderer.any_instance.stub(:factory).with(:item, subject).and_return(renderer_stub)

          renderer_stub.should_receive(:render)
          subject.render
        end

      end

      it "renders through a specified strategy when given" do
        class FakeRenderingStrategy; end
        FakeRenderingStrategy.any_instance.stub(:factory).with(:item, subject).and_return(renderer_stub)

        renderer_stub.should_receive(:render)
        subject.render(FakeRenderingStrategy.new)
      end

    end

  end

end

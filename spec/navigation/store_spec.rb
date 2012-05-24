require 'spec_helper'

module Mariner

  describe Store do

    it "is a subclass of Abyss::DeepStore" do
      subject.should be_a ::Abyss::DeepStore
    end

    describe "#virtual?" do

      it "aliases the attribute reader" do
        subject.method(:virtual).should == subject.method(:virtual?)
      end

    end

    describe "#initialize" do

      subject { Store.new }

      its(:virtual?) { should be_false }

    end

    describe "#assign" do

      context "by default" do

        it "stores a new Url with a method_name, title, and link_options" do
          url_stub = stub
          Url.should_receive(:new).with(:some_undefined_method, 'A Title', { :option => 'value' }).and_return(url_stub)
          subject.assign(:some_undefined_method, ['A Title', { :option => 'value' }])
          subject.configurations[:some_undefined_method].should == url_stub
        end

      end

      context "when given an incorrect number of values" do

        it "raises an argument error" do
          expect {
            subject.assign(:some_undefined_method, ['One', 'Two', 'Three'])
          }.to raise_error ArgumentError, /wrong number of values specified \(3 for <= 2\)/i
        end

      end

    end

    describe "#render" do

      let(:renderer_stub) { stub }

      context "by default" do

        it "uses a default rendering strategy" do
          UnorderedListRenderer.any_instance.stub(:factory).with(:group, subject).and_return(renderer_stub)

          renderer_stub.should_receive(:render)
          subject.render
        end

      end

      it "renders through a specified strategy when given" do
        class FakeRenderingStrategy; end
        FakeRenderingStrategy.any_instance.stub(:factory).with(:group, subject).and_return(renderer_stub)

        renderer_stub.should_receive(:render)
        subject.render(FakeRenderingStrategy.new)
      end

    end

  end

end

require 'spec_helper'

module Abyss

  module Navigation

    describe Url do

      describe "#initialize" do

        subject { Url.new(:foo_path, "Thing", {option: 'bar'}) }

        its(:name)         { should == :foo_path }
        its(:title)        { should == "Thing" }
        its(:link_options) { should == {option: 'bar'} }

      end

      describe "#render" do

        subject { Url.new(:foo_path, "Thing", {class: "a-link"}) }

        it "renders a link properly" do
          # Here we're making an assumption that through some mechanism outside
          # the concern of this test, Url will know about the path's it's being
          # asked to know about. The currently planned way is to include
          # Rails.application.routes.url_helpers in an initializer, but this
          # is subject to change.
          #
          subject.stub(:foo_path).and_return('/foo/bar.baz')

          rendered = subject.render
          rendered.should =~ /<a.*>Thing<\/a>/ # content
          rendered.should =~ /href=['"]\/foo\/bar.baz['"]/ # path
          rendered.should =~ /class=['"]a-link foo_path['"]/
        end

        context "when trying to use a link that is undefined" do

          subject { Url.new(:undefined_path, "Undefined", {option: 'bar'}) }

          it "raises an error" do
            expect {
              subject.render
            }.to raise_error ::Abyss::Errors::InvalidUrlHelperMethod, /Unknown url helper method.*undefined_path/
          end

        end

      end

    end

  end

end

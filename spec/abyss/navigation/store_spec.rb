require 'spec_helper'

module Abyss

  module Navigation

    describe ".configure" do

      before { Navigation.configuration = nil }
      after  { Navigation.configuration = nil }

      it 'is shorthand for the Navigation Config API' do
        expected_block = Proc.new { }
        fake_config = mock()
        Store.stub(:new).and_return(fake_config)
        fake_config.should_receive(:instance_eval).with(&expected_block)

        Navigation.configure &expected_block
      end

    end

    describe Store do

      it "is a subclass of DeepStore" do
        subject.should be_a ::Abyss::DeepStore
      end

      describe "#assign" do

        context "by default" do

          it "stores a new Url with a method_name, title, and link_options" do
            url_stub = stub
            Url.should_receive(:new).with(:some_undefined_method, 'A Title', { option: 'value' }).and_return(url_stub)
            subject.assign(:some_undefined_method, ['A Title', { option: 'value' }])
            subject.configurations[:some_undefined_method].should == url_stub
          end

        end

        context "without link options" do

          it "stores a new Url with an empty hash of link options" do
            Url.should_receive(:new).with(:some_undefined_method, 'A Title', {})
            subject.assign(:some_undefined_method, ['A Title'])
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

        describe "integration-y behaviors" do

          before { Url.any_instance.stub(:render).and_return("foo") }

          it "renders an empty group properly" do
            subject.nonexistent_group {}
            subject.render.should =~ /<ul.*><\/ul>/
          end

          it "renders an item properly" do
            subject.nonexistent_thing 'foo'
            subject.render.should =~ /foo/
          end

          it "recursively renders groups and items properly" do
            r  = "<ul[^>]*>" # nonexistent_group
              r << "<li>foo</li>" # nonexistent_thing
              r << "<li>"
                r << "<ul[^>]*>" # sub_nonexistent_thing
                  r << "<li>foo</li>" # deep_nonexistent_thing
                r << "</ul>"
              r << "</li>"
            r << "</ul>"

            subject.nonexistent_group do
              nonexistent_thing "foo"
              sub_nonexistent_thing do
                deep_nonexistent_thing "bar!!!"
              end
            end

            subject.render.should =~ Regexp.new(r)
          end

          context "when rendering titles" do

            it "includes a title list item" do
              r  = "<ul.*>" # nonexistent_group
                r << "<li>Nonexistent Group</li>" # group title
                r << "<li>foo</li>" # nonexistent_thing
              r << "</ul>"

              subject.nonexistent_group do
                nonexistent_thing "foo"
              end

              subject.render(include_title: true).should =~ Regexp.new(r)
            end

          end

        end

      end

    end

  end

end

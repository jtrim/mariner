require 'spec_helper'

module Abyss

  module Navigation

    describe Helper, :type => :helper do

      before do
        Abyss::Navigation.configure do
          a_group do
            root_path "A Thing!"
            a_sub_group {}
          end
        end
      end

      after { Abyss::Navigation.configuration = nil }

      describe "#render_navigation" do

        context "with no args" do

          it "renders the root level configuration" do
            Abyss::Navigation.configuration.should_receive(:render)
            render_navigation
          end

        end

        context "with one arg" do

          it "renders the correct configuration" do
            Abyss::Navigation.configuration.should_not_receive(:render)
            Abyss::Navigation.configuration.a_group.should_receive(:render)
            render_navigation :a_group
          end

        end

        context "with two args" do

          context "when renderer is a symbol" do

            it "gets its renderer from Abyss::Navigation.rendering_strategies" do
              fake_renderer = stub(:render => nil)
              Abyss::Navigation.rendering_strategies[:fake] = fake_renderer

              Abyss::Navigation.configuration.should_not_receive(:render)
              Abyss::Navigation.configuration.a_group.should_receive(:render).with(fake_renderer)

              render_navigation :a_group, :fake
            end

            it "raises an error if the specified renderer doesn't exist" do
              Abyss::Navigation.rendering_strategies[:nonexistent] = nil
              expect {
                render_navigation :a_group, :nonexistent
              }.to raise_error /rendering strategy not found/i
            end

          end

          context "when renderer is not a symbol" do

            it "renders with a specified strategy" do
              fake_renderer = stub(:render => nil)
              Abyss::Navigation.configuration.should_not_receive(:render)
              Abyss::Navigation.configuration.a_group.should_receive(:render).with(fake_renderer)

              render_navigation :a_group, fake_renderer
            end

          end

        end

        context "with a string path" do

          it "calls through to #render properly" do
            Abyss::Navigation.configuration.should_not_receive(:render)
            Abyss::Navigation.configuration.a_group.should_receive(:render)

            render_navigation "a_group"
          end

        end

        context "with a deep string path" do

          it "calls through to #render properly" do
            Abyss::Navigation.configuration.should_not_receive(:render)
            Abyss::Navigation.configuration.a_group.should_not_receive(:render)
            Abyss::Navigation.configuration.a_group.a_sub_group.should_receive(:render)
            render_navigation "a_group/a_sub_group"
          end

        end

      end

    end

  end

end

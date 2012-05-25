require 'spec_helper'

module Mariner

  describe Helper, :type => :helper do

    before do
      Mariner.configure do
        a_group do
          root_path "A Thing!"
          a_sub_group {}
        end
      end
    end

    after { Mariner.configuration = nil }

    describe "#render_navigation" do

      context "with no args" do

        it "renders the root level configuration" do
          Mariner.configuration.should_receive(:render)
          render_navigation
        end

      end

      context "with one arg" do

        it "renders the correct configuration" do
          Mariner.configuration.should_not_receive(:render)
          Mariner.configuration.a_group.should_receive(:render)
          render_navigation :a_group
        end

      end

      context "with two args" do

        context "when renderer is a symbol" do

          it "gets its renderer from Mariner.rendering_strategies" do
            fake_renderer = stub(:render => nil)
            Mariner.rendering_strategies[:fake] = fake_renderer

            Mariner.configuration.should_not_receive(:render)
            Mariner.configuration.a_group.should_receive(:render).with(fake_renderer)

            render_navigation :a_group, :fake
          end

          it "raises an error if the specified renderer doesn't exist" do
            Mariner.rendering_strategies[:nonexistent] = nil
            expect {
              render_navigation :a_group, :nonexistent
            }.to raise_error /rendering strategy not found/i
          end

        end

        context "when renderer is not a symbol" do

          it "renders with a specified strategy" do
            fake_renderer = stub(:render => nil)
            Mariner.configuration.should_not_receive(:render)
            Mariner.configuration.a_group.should_receive(:render).with(fake_renderer)

            render_navigation :a_group, fake_renderer
          end

        end

      end

      context "with a string path" do

        it "calls through to #render properly" do
          Mariner.configuration.should_not_receive(:render)
          Mariner.configuration.a_group.should_receive(:render)

          render_navigation "a_group"
        end

      end

      context "with a deep string path" do

        it "calls through to #render properly" do
          Mariner.configuration.should_not_receive(:render)
          Mariner.configuration.a_group.should_not_receive(:render)
          Mariner.configuration.a_group.a_sub_group.should_receive(:render)
          render_navigation "a_group/a_sub_group"
        end

      end

    end

    describe "#render_sub_navigations" do

      before do
        Mariner.configure do
          root_path "Top"

          group_one do
            root_path "One"
          end

          group_two do
            root_path "Two"
          end
        end
      end

      it "renders the navigations within the target group without rendering the target itself" do
        Mariner.configuration.should_not_receive(:render)

        Mariner.configuration.configurations.each do |c|
          _, entity = c
          entity.should_receive(:render)
        end

        render_sub_navigations
      end

    end

    describe "#render_navigations" do

      before do
        Mariner.configure do
          group_one {}
          group_two do
            sub_group {}
          end
          group_three {}
        end

      end

      context "without rendering options" do

        it "renders each navigation given" do
          helper.should_receive(:render_navigation).with('group_two/sub_group').once.ordered
          helper.should_receive(:render_navigation).with(:group_three).once.ordered

          helper.render_navigations 'group_two/sub_group', :group_three
        end

      end

      context "with rendering options" do

        it "renders each navigation with the specified renderer" do
          helper.should_receive(:render_navigation).with('group_two/sub_group', :default).once.ordered
          helper.should_receive(:render_navigation).with(:group_three, :default).once.ordered

          helper.render_navigations 'group_two/sub_group', :group_three, :rendering_strategy => :default
        end

      end

    end

  end

end

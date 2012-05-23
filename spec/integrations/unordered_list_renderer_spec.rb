require 'spec_helper'

# This test suite is kind of a hack just to access
# the capybara matchers.

# TODO: Figure out how to do this better.

module Abyss

  module Navigation

    describe UnorderedListRenderer do

      before do
        Abyss::Navigation.configure do
          quick_links do
            root_path "Home"
          end
        end
      end

      after { Abyss::Navigation.configuration = nil }

      # Work within the context of an anonymous controller
      #
      describe Class.new(ActionController::Base), :type => :controller do

        subject { get :index; response.body }

        describe "rendered element classnames" do

          controller do
            def index
              render_options = {
                :render_titles => true,
                :group_classname => 'nav-list',
                :title_classname => 'nav-title',
                :item_classname => 'nav-item'
              }
              strategy = UnorderedListRenderer.new(render_options)
              render :text => Abyss::Navigation.configuration.render(strategy)
            end
          end

          it "uses the classnames provided" do
            subject.should have_css "ul.nav-list li:first-child.nav-title"
            subject.should have_css "ul.nav-list li:last-child a.nav-item"
          end

        end

        describe "the rendering of titles" do

          context "when render_titles is false on the rendering strategy" do

            controller do
              def index
                strategy = UnorderedListRenderer.new(:render_titles => false)
                render :text => Abyss::Navigation.configuration.render(strategy)
              end
            end

            it "suppresses titles" do
              subject.should_not have_css 'ul li:first-child', :text => 'Quick Links'
              subject.should have_css 'ul li:last-child a[href="/"]', :text => 'Home'
            end

          end

          context "when render_titles is true" do

            controller do
              def index
                strategy = UnorderedListRenderer.new(:render_titles => true)
                render :text => Abyss::Navigation.configuration.render(strategy)
              end
            end

            it "suppresses titles" do
              subject.should have_css 'ul li:first-child', :text => 'Quick Links'
              subject.should have_css 'ul li:last-child a[href="/"]', :text => 'Home'
            end

          end

        end

      end

    end

  end

end

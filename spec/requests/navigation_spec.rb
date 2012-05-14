require 'spec_helper'

describe 'Navigation rendering' do

  context "with navigation configuration defined" do

    before do
      # See spec/rails_app/config/routes.rb for routes defined.
      #
      Abyss::Navigation.configure do

        normal_nav do
          topbar do
            foo_path "Here's the path to foo"
            bar_path "And here for bar"
            root_path "Go back to root"
          end
        end

        condensed_nav do
          topbar do
            foo_path "This is condensed Foo."
            bar_path "And here for bar"
            root_path "Go back to root"
          end
        end

      end
    end

    context "when rendering the 'normal_nav' group" do

      it "renders links on the page" do
        visit '/normal'

        page.should have_css 'a', text: "Here's the path to foo"
        page.should have_css 'a', text: "And here for bar"
        page.should have_css 'a', text: "Go back to root"

        page.should_not have_css 'a', text: "This is condensed Foo."
      end

    end

    context "when rendering the 'condensed_nav' group" do


      it "renders links on the page" do
        visit '/condensed'

        page.should have_css 'a', text: "This is condensed Foo."
        page.should have_css 'a', text: "And here for bar"
        page.should have_css 'a', text: "Go back to root"

        page.should_not have_css 'a', text: "Here's the path to foo"
      end

    end

  end

end

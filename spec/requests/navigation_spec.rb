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
            foo_path "Here's the path to foo"
            bar_path "And here for bar"
            root_path "Go back to root"
          end
        end

      end
    end

    it "renders links on the page" do

    end

  end

end

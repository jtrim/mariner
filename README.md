# Mariner

[![Build Status](https://secure.travis-ci.org/jtrim/mariner.png)](http://travis-ci.org/jtrim/mariner)

Mariner helps you manage your site's navigation through a friendly DSL.

## Installation

Add this line to your application's Gemfile:

    gem 'mariner'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mariner

## Usage

Mariner helps you define trees of links through a friendly DSL:

    Mariner.configure do

      topbar do # <= arbitrarily-named

        # Defining Urls is as easy as calling the
        # Rails route helper you want to use:

        root_path 'Home'

        # by default, the above renders <a href="/">Home</a>

        dropdown do # <= also arbitrarily-named

          # If you specify options, they're passed on to the renderer
          destroy_user_session_path "Logout", "data-method" => :destroy

        end

      end

    end

After creating your nav, render it in your views with:

    <%= render_navigation :topbar %>

See Mariner::Helper for usage on `render_navigation`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes and tests (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

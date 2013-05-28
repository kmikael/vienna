# Vienna

`Vienna` is a tiny, zero-configuration static file server built on top of `rack`.
The goal is to place everything in `/public`, add two lines to our `config.ru`
and let `Vienna` take care of the rest.

Why Vienna? Because it's an awesome city and It's the first thing that came to my mind.
(I must have gotten the idea from [Cuba](http://cuba.is).)

## Installation

Add this line to your application's Gemfile:

    gem 'vienna'

And then execute:

    bundle

Or install it yourself, run:

    gem install vienna

## Usage

Place your static files in `/public`, optionally create `/public/404.html`
and add this to your `config.ru`:

    require 'vienna'
    run Vienna

You're done. Now you can deploy to `heroku` or any other place that supports
rack-based apps. This should also work for most apps built with
[Jekyll](http://jekyllrb.com) or [Middleman](http://middlemanapp.com) as long as
you follow the conventions stated above.

If you absolutely must change the root folder for some reason. You can use e.g.
`run Vienna::Application.new('_site')` instead of `run Vienna`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

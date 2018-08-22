# Spotlight::Resources::Dri

Spotlight Resource Harvester for DRI.  A Rails engine gem for use in the blacklight-spotlight Rails engine gem.

This is based on the work done in https://github.com/harvard-library/spotlight-oaipmh-resources and https://github.com/sul-dlss-deprecated/spotlight-resources-iiif.

## Installation

Add this line to your blacklight-spotlight Rails application's Gemfile:

```ruby
gem 'spotlight-resources-dri'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spotlight-resources-dri

Then run the engine's generator:

    $ rails generate spotlight:resources:dri:install

## Usage

This is a Rails engine gem to be used along with blacklight-spotlight, another Rails engine gem used to build exhibits sites while leveraging the blacklight Rails engine gem.

This gem adds a new "Repository Item" form to your Spotlight application. This form allows curators to input a list of DRI object ids that will be harvested as new items in the Spotlight exhibit.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Digital-Repository-of-Ireland/spotlight-resources-dri.


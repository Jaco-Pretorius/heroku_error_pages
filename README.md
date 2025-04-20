# HerokuErrorPages

Heroku allows you to configure custom error pages for application/launch errors and maintenance mode. https://devcenter.heroku.com/articles/error-pages#customize-pages

This gem allows you to easily generate one or both of these pages during your Heroku deployment and store the static HTML on Amazon S3. This means your custom error pages are always using your latest stylesheets. You simply supply the template and S3 configuration variables.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add heroku_error_pages

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install heroku_error_pages

## Usage

Configure the error and/or maintenance pages. For a rails application, create a file like `config/initializers/heroku_error_pages.rb`.

Sample configuration:

```
HerokuErrorPages.configure do |config|
  # Required
  config.s3_bucket_name = "your-s3-bucket-name"

  # Optional
  config.aws_access_key_id = "aws-secret-key-id" # defaults to `ENV["AWS_ACCESS_KEY_ID"]`
  config.aws_secret_access_key = "aws-secret-access-key" # defaults to `ENV["AWS_SECRET_ACCESS_KEY"]`
  config.aws_region = "some-region" # defaults to `us-east-1`

  # at least one page must be configured
  config.configure_error_page(
    template: 'errors/show', # the Rails template to render
    assigns: { # optional, any variables to assign to the template
      status: :internal_server_error
    },
    controller: ErrorsController # optional, defaults to ActionController::Base
  )

  config.configure_maintenance_page(
    # same options as configure_error_page
  )
end
```

Add this to your `Procfile` to configure Heroku to deploy your custom pages as part of deployments:

```
release: bundle exec rake heroku_error_pages:deploy
```

You can verify that your error pages are being served correctly out of S3 by navigating there in your browser, eg. `https://your-s3-bucket.s3.amazonaws.com/application_error.html`. Once you are satisfied you can configure Heroku to use your custom error pages:

```
heroku config:set \
  ERROR_PAGE_URL=//your-s3-bucket.s3.amazonaws.com/application_error.html \
  MAINTENANCE_PAGE_URL=//your-s3-bucket.s3.amazonaws.com/your_maintenance_page.html
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jaco-Pretorius/heroku_error_pages.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

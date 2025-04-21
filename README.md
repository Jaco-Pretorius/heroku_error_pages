# HerokuErrorPages

[![CI](https://github.com/Jaco-Pretorius/heroku_error_pages/actions/workflows/ci.yml/badge.svg)](https://github.com/Jaco-Pretorius/heroku_error_pages/actions/workflows/ci.yml)

Heroku allows you to configure [custom error pages](https://devcenter.heroku.com/articles/error-pages#customize-pages) for application errors and maintenance mode.

This gem allows you to develop the pages in your Rails application, generate the pages during Heroku deployments, and store the static HTML on Amazon S3. This means your custom error pages are always kept up-to-date.

There are 3 areas of configuration:
- Gem Installation and Configuration
- AWS Configuration
- Heroku Configuration

## Gem Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add heroku_error_pages

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install heroku_error_pages

## Gem Configuration

Configure the error and/or maintenance pages via an initializer in `config/initializers/heroku_error_pages.rb`.

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
    layout: 'public' # optional, defaults to 'application'
  )

  config.configure_maintenance_page(
    # same options as configure_error_page
  )
end
```

## AWS Configuration

The AWS user specified in the configuration must have `s3:PutObject` permissions for the specified AWS S3 bucket. The gem does not specify any ACLs for the uploaded files, so the bucket policy must allow public access to the files.

The gem prefixes all files with `heroku_error_pages/` to avoid conflicts with other files in the bucket. You can therefore apply a single bucket policy to allow public access to only the files with this prefix.

This example policy will allow public access to all files with the prefix `heroku_error_pages/` (make sure you replace `YOUR_BUCKET_NAME_HERE` with your actual bucket name):

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowPublicReadForHerokuErrorPages",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR_BUCKET_NAME_HERE/heroku_error_pages/*"
        }
    ]
```

In order to use a policy for allowing public access, configure your bucket like this:

- ☑️ Block public access to buckets and objects granted through new access control lists (ACLs)
- ☑️ Block public access to buckets and objects granted through any access control lists (ACLs)
- ⬜ Block public access to buckets and objects granted through new public bucket or access point policies
- ⬜ Block public and cross-account access to buckets and objects through any public bucket or access point policies

## Heroku Configuration

Configure the Heroku `Procfile` to deploy your custom pages as part of deployments:

```
release: bundle exec rake heroku_error_pages:deploy
```

This rake task will generate `error_page.html` and/or `maintenance_page.html` and upload all the relevant assets (CSS, JS, images) to the S3 bucket in the `heroku_error_pages/` folder/prefix. This should ensure that the custom error pages have all assets referenced correctly via relative paths.

You can verify that your error pages have the necessary permissions and are being served correctly out of S3 by navigating there in your browser, i.e. `https://your-s3-bucket.s3.amazonaws.com/heroku_error_pages/error_page.html` or `https://your-s3-bucket.s3.amazonaws.com/heroku_error_pages/maintenance_page.html`. Once you are satisfied you can configure Heroku to use your custom error pages:

```
heroku config:set \
  ERROR_PAGE_URL=//your-s3-bucket.s3.amazonaws.com/heroku_error_pages/error_page.html \
  MAINTENANCE_PAGE_URL=//your-s3-bucket.s3.amazonaws.com/heroku_error_pages/maintenance_page.html
```

The pages will be refreshed automatically as part of every deployment, which ensures that any style changes are automatically applied.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jaco-Pretorius/heroku_error_pages.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

# frozen_string_literal: true

require_relative "lib/heroku_error_pages/version"

Gem::Specification.new do |spec|
  spec.name = "heroku_error_pages"
  spec.version = HerokuErrorPages::VERSION
  spec.authors = ["Jaco Pretorius"]
  spec.email = ["me@jacopretorius.net"]

  spec.summary = "Deploy your custom Heroku error pages to S3 as part of your app deployment"
  spec.description = "Continuously deploy your custom Heroku error pages to S3 as part of your deployment pipeline"
  spec.homepage = "https://github.com/Jaco-Pretorius/heroku_error_pages"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "aws-sdk-s3", "~> 1"
  spec.add_dependency "rails", ">= 6.0", "< 8.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end

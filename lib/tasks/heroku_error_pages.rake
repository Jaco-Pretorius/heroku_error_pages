# frozen_string_literal: true

namespace :heroku_error_pages do
  desc "Generate error pages and upload to S3"
  task deploy: :environment do
    HerokuErrorPages.deploy
  end

  task configure_bucket_policy: :environment do
    HerokuErrorPages.configure_bucket_policy
  end
end

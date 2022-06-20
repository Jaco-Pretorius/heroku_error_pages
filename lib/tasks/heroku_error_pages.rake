namespace :heroku_error_pages do
  desc 'Generate error pages and upload to S3'
  task deploy: :environment do
    HerokuErrorPages.deploy
  end
end

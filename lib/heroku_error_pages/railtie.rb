if defined?(Rails)
  module HerokuErrorPages
    class Railtie < Rails::Railtie
      rake_tasks do
        load "tasks/heroku_error_pages.rake"
      end
    end
  end
end

module HerokuErrorPages
  class Config
    attr_accessor :aws_access_key_id, :aws_secret_access_key, :aws_region, :s3_bucket_name
    attr_reader :error_page, :maintenance_page

    def initialize
      @aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
      @aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
      @aws_region = 'us-east-1'
    end

    def configure_error_page(s3_path:, template:, assigns: nil, controller: nil)
      @error_page = PageConfig.new(
        s3_path: s3_path,
        template: template,
        assigns: assigns,
        controller: controller
      )
    end

    def config_maintenance_page(s3_path:, template:, assigns: nil, controller: nil)
      @maintenance_page = PageConfig.new(
        s3_path: s3_path,
        template: template,
        assigns: assigns,
        controller: controller
      )
    end
  end
end

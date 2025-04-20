# frozen_string_literal: true

module HerokuErrorPages
  class Config
    attr_accessor :aws_access_key_id, :aws_secret_access_key, :aws_region, :s3_bucket_name
    attr_reader :error_page, :maintenance_page

    def initialize
      @aws_access_key_id = ENV.fetch("AWS_ACCESS_KEY_ID", nil)
      @aws_secret_access_key = ENV.fetch("AWS_SECRET_ACCESS_KEY", nil)
      @aws_region = "us-east-1"
    end

    def configure_error_page(template:, assigns: nil, layout: nil)
      @error_page = PageConfig.new(
        template: template,
        assigns: assigns,
        layout: layout
      )
    end

    def configure_maintenance_page(template:, assigns: nil, layout: nil)
      @maintenance_page = PageConfig.new(
        template: template,
        assigns: assigns,
        layout: layout
      )
    end
  end
end

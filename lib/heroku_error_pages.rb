# frozen_string_literal: true

require_relative "heroku_error_pages/version"
require_relative "heroku_error_pages/config"
require_relative "heroku_error_pages/page_config"
require_relative "heroku_error_pages/railtie"
require_relative "heroku_error_pages/renderer"
require_relative "heroku_error_pages/public_asset"
require "aws-sdk-s3"

module HerokuErrorPages
  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end

    def deploy
      raise "No custom pages were configured" unless config.error_page || config.maintenance_page

      s3_client = Aws::S3::Client.new(
        credentials: Aws::Credentials.new(
          config.aws_access_key_id,
          config.aws_secret_access_key
        ),
        region: config.aws_region
      )

      deploy_page(config.error_page, s3_client)
      deploy_page(config.maintenance_page, s3_client)
      deploy_public_assets(s3_client)
    end

    private

    def deploy_page(page_config, s3_client)
      return if page_config.nil?

      s3_object = Aws::S3::Object.new(config.s3_bucket_name, page_config.s3_path, client: s3_client)
      s3_object.put(
        body: Renderer.render_html(page_config),
        content_type: "text/html"
      )
    end

    def deploy_public_assets(s3_client)
      PublicAsset.all.each do |public_asset|
        s3_absolute_path = "#{config.s3_bucket_name}/#{public_asset.relative_path}"
        Rails.logger.info "Uploading #{public_asset.absolute_path} to #{s3_absolute_path}"

        s3_object = Aws::S3::Object.new(config.s3_bucket_name, public_asset.relative_path, client: s3_client)
        s3_object.upload_file(
          public_asset.absolute_path,
          acl: "public-read",
          content_type: public_asset.mime_type
        )
      end
    end
  end
end

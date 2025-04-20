# frozen_string_literal: true

RSpec.describe HerokuErrorPages::Config do
  context "with AWS configuration via ENV variables" do
    around do |example|
      original_env = ENV.to_hash

      ENV["AWS_ACCESS_KEY_ID"] = "test-key-id"
      ENV["AWS_SECRET_ACCESS_KEY"] = "test-secret-key"

      example.run

      ENV.replace(original_env)
    end

    it "uses the ENV variables" do
      expect(subject.aws_access_key_id).to eq("test-key-id")
      expect(subject.aws_secret_access_key).to eq("test-secret-key")
      expect(subject.aws_region).to eq("us-east-1")
    end
  end

  context "without ENV variables specified" do
    it "provides a default for the aws region" do
      expect(subject.aws_access_key_id).to be_nil
      expect(subject.aws_secret_access_key).to be_nil
      expect(subject.aws_region).to eq("us-east-1")
    end
  end

  it "configures the error page" do
    expect(subject.error_page).to be_nil

    subject.configure_error_page(
      template: "errors/internal_server_error",
      assigns: {
        status_code: 500
      },
      layout: "public"
    )

    expect(subject.error_page.template).to eq("errors/internal_server_error")
    expect(subject.error_page.assigns).to eq({ status_code: 500 })
    expect(subject.error_page.layout).to eq("public")
  end

  it "configures the maintenance page" do
    expect(subject.maintenance_page).to be_nil

    subject.configure_maintenance_page(template: "errors/maintenance")

    expect(subject.maintenance_page.template).to eq("errors/maintenance")
    expect(subject.maintenance_page.assigns).to eq({})
    expect(subject.maintenance_page.layout).to eq("application")
  end

  it "allows configuration via the module helper" do
    HerokuErrorPages.configure do |config|
      config.s3_bucket_name = "my-s3-bucket"
      config.configure_maintenance_page(template: "errors/maintenance")
    end

    expect(HerokuErrorPages.config.s3_bucket_name).to eq("my-s3-bucket")
    expect(HerokuErrorPages.config.maintenance_page.template).to eq("errors/maintenance")
  end
end

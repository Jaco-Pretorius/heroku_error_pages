# frozen_string_literal: true

RSpec.describe HerokuErrorPages do
  it "has a version number" do
    expect(HerokuErrorPages::VERSION).not_to be nil
  end

  describe ".deploy" do
    context "when no pages are configured" do
      it "raises" do
        expect(described_class.config.error_page).to be_nil
        expect(described_class.config.maintenance_page).to be_nil
        expect { described_class.deploy }.to raise_error("No custom pages were configured")
      end
    end
  end
end

# frozen_string_literal: true

module HerokuErrorPages
  class Renderer
    class << self
      def render_html(page_config)
        new(page_config.template, page_config.assigns, page_config.layout).html
      end
    end

    def initialize(template, assigns, layout)
      @template = template
      @assigns = assigns
      @layout = layout
    end

    def html
      @html ||= generate_html
    end

    private

    attr_reader :template, :assigns, :layout

    def generate_html
      controller = Class.new(ActionController::Base) do
        self.asset_host = nil
        self.relative_url_root = "/#{HerokuErrorPages::S3_PREFIX}"
      end

      controller.render(template: template, assigns: assigns, layout: layout)
    end
  end
end

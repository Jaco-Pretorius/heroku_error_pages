# frozen_string_literal: true

module HerokuErrorPages
  class Renderer
    class << self
      def render_html(page_config)
        new(page_config.template, page_config.assigns, page_config.controller).html
      end
    end

    def initialize(template, assigns, controller)
      @template = template
      @assigns = assigns
      @controller = controller
    end

    def html
      @html ||= generate_html
    end

    private

    attr_reader :template, :assigns, :controller

    def generate_html
      controller = Class.new(controller) do
        self.asset_host = nil
      end

      controller.render(template: template, assigns: assigns)
    end
  end
end

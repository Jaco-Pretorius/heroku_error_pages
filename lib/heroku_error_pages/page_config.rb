# frozen_string_literal: true

module HerokuErrorPages
  class PageConfig
    attr_accessor :template, :assigns, :layout

    def initialize(template:, assigns:, layout:)
      @template = template
      @assigns = assigns || {}
      @layout = layout || "application"
    end
  end
end

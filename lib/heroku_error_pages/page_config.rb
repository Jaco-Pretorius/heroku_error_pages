# frozen_string_literal: true

module HerokuErrorPages
  class PageConfig
    attr_accessor :template, :assigns, :controller

    def initialize(template:, assigns:, controller:)
      @template = template
      @assigns = assigns || {}
      @controller = controller || ActionController::Base
    end
  end
end

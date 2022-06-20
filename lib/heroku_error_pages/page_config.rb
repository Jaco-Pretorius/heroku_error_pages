module HerokuErrorPages
  class PageConfig
    attr_accessor :s3_path, :template, :assigns, :controller

    def initialize(s3_path:, template:, assigns:, controller:)
      @s3_path = s3_path
      @template = template
      @assigns = assigns || {}
      @controller = controller || ActionController::Base
    end
  end
end

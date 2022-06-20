module HerokuErrorPages
  class PublicAsset
    class << self
      def all
        Dir.glob(Rails.public_path.join('*', '**')).map do |absolute_path|
          new(absolute_path)
        end
      end
    end

    attr_reader :absolute_path

    def initialize(absolute_path)
      @absolute_path = absolute_path
    end

    def relative_path
      @relative_path ||= Pathname.new(absolute_path).relative_path_from(Rails.public_path).to_s
    end

    def mime_type
      extension = File.extname(absolute_path).strip.downcase[1..-1]
      Mime::Type.lookup_by_extension(extension)&.to_s
    end
  end
end

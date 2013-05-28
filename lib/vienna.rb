require 'vienna/version'
require 'rack'

##
# Zero-configuration convenience wrapper around `Vienna::Application`.
# Add this to `config.ru`:
#
#     require 'vienna'
#     run Vienna
#
# Your static site in `public` will be served.
#

module Vienna

  class << self
    def call(env)
      Application.new.call(env)
    end
  end
  
  ##
  # `Vienna::NotFound` is a default endpoint not unlike `Rack::NotFound`.
  # Initialize it with the path to a 404 page and it will get returned.
  # The difference is that if a 404 page doesn't exist, a default
  # response, 'Not Found' will be returned.
  #
  # Examples
  #
  #     run Vienna::NotFound.new('public/404.html')
  #
  #     run Vienna::NotFound.new # Always return 'Not Found'
  #
  
  class NotFound
    def initialize(path = '')
      @path = path
      @content = 'Not Found'
    end
    
    def call(env)
      if ::File.exist?(@path)
        @content = ::File.read(@path)
      end
      length = @content.length.to_s
      [404, {'Content-Type' => 'text/html', 'Content-Length' => length}, [@content]]
    end
  end
  
  ##
  # `Vienna::Application` serves all files under the given `root`
  # using `Rack::Static`. If a file/path doen't exist,
  # `Vienna::NotFound` is run, which always returns `404`.
  # 
  # Examples
  #
  #     run Vienna::Application.new('_site')
  #
  #     run Vienna::Application.new # The root defaults to 'public'
  #
  
  class Application
    def initialize(root = 'public')
      @app = Rack::Builder.new do
        use Rack::Static,
          :urls => Dir.glob("#{root}/*").map { |fn| fn.gsub(/#{root}/, '')},
          :root => root,
          :index => 'index.html',
          :header_rules => [[:all, {'Cache-Control' => 'public, max-age=3600'}]]
        
        run NotFound.new("#{root}/404.html")
      end
    end
    
    def call(env)
      @app.call(env)
    end
  end
end

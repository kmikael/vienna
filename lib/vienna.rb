require 'vienna/version'
require 'rack'

##
# Zero-configuration convenience wrapper around `Vienna::Application`.
# Add this to your `config.ru`:
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
  # `Vienna::Static` is just a wrapper for `Rack::Static` with
  # sane and opinionated options.
  #
  # It serves all files under the given `root` and doesn't passes on requests
  # for files that don't exist.
  #
  # Examples
  #
  #     use Vienna::Static, 'public'
  #
  
  class Static
    def initialize(app, root)
      @app = app
      @root = root
    end
    
    def urls
      Dir.glob("#{root}/*").map { |f| f.sub(root, '') }.prepend("/")
    end
    
    def root
      @root
    end
    
    def index
      'index.html'
    end
    
    def header_rules
      [[:all, {'Cache-Control' => 'public, max-age=3600'}]]
    end
    
    def options
      {urls: urls, root: root, index: index, header_rules: header_rules, cascade: true}
    end
    
    def call(env)
      Rack::Static.new(@app, options).call(env)
    end
  end
  
  ##
  # `Vienna::NotFound` is a default endpoint not unlike `Rack::NotFound`.
  # Initialize it with the path to a 404 page and its contents will be served.
  # The difference is that if a 404 page doesn't exist, a default response,
  # 'Not Found' will be served.
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
    end
    

    def content
      File.exist?(@path) ? File.read(@path) : 'Not Found'
    end

    def content_length
      content.length.to_s
    end

    def status
      404
    end

    def headers
      {
        'Content-Type' => 'text/html',
        'Content-Length' => content_length
      }
    end

    def body
      [content]
    end

    def call(env)
      [status, headers, body]
    end
  end
  
  ##
  # `Vienna::Application` serves all files under the given root directory
  # using `Vienna::Static`. If a file/path doen't exist, `Vienna::NotFound`
  # is run, which always returns a status of `404` and the contents of
  # `404.html` or `'Not Found'` if one does not exist.
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
        use Static, root
        run NotFound.new("#{root}/404.html")
      end
    end
    
    def call(env)
      @app.call(env)
    end
  end
end

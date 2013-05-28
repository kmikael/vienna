require 'vienna/version'
require 'rack'

module Vienna
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
  
  class Application
    def initialize(root)
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
  
  class << self
    def call(env)
      Application.new('public').call(env)
    end
  end
end

require 'vienna/version'
require 'rack'

module Vienna
  class NotFound
    def initialize(path)
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
    def initialize
      @app = Rack::Builder.new do
        use Rack::Static,
          :urls => Dir.glob('public/*').map { |fn| fn.gsub(/public/, '')},
          :root => 'public',
          :index => 'index.html',
          :header_rules => [[:all, {'Cache-Control' => 'public, max-age=3600'}]]
        
        run NotFound.new('public/404.html')
      end
    end
    
    def call(env)
      @app.call(env)
    end
  end
  
  def self.call(env)
    Application.new.call(env)
  end
end

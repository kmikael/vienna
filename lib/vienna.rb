require 'vienna/version'
require 'rack'

module Vienna
  class NotFound
    def initialize(path)
      @content = ::File.read(path)
      @length = @content.length.to_s
    end
    
    def call(env)
      [404, {'Content-Type' => 'text/html', 'Content-Length' => @length}, [@content]]
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
        path = 'public/404.html'
        if File.exist? path
          run NotFound.new path
        else
          run lambda { |env| [404, {'Content-Type' => 'text/html'}, ['Not Found']]}
        end
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

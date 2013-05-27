require 'vienna/version'
require 'rack'

module Vienna
  def self.app
    Rack::Builder.new do
      use Rack::Static,
        :urls => Dir.glob('public/*').map { |fn| fn.gsub(/public/, '')},
        :root => 'public',
        :index => 'index.html',
        :header_rules => [[:all, {'Cache-Control' => 'public, max-age=3600'}]]
      run lambda { |env| [404, {'Content-Type' => 'text/html'}, ['Not Found']]}
    end
  end
  
  def self.call(env)
    app.call(env)
  end
end

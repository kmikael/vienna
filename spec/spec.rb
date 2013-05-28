require 'minitest/autorun'
require 'rack/mock'
require 'vienna'

describe Vienna do
  before do
    app = Rack::Builder.new do
      use Rack::Lint
      run Vienna
    end
    @request = Rack::MockRequest.new(app)
  end
  
  it 'should serve the index when getting root' do
    res = @request.get '/'
    res.body.chomp.must_equal 'index'
    [200, 304].must_include res.status
  end
  
  it 'should serve all files in the public directory' do
    @request.get('/css/style.css').body.chomp.must_equal 'style'
    @request.get('/images/image.svg').body.chomp.must_equal 'image'
    @request.get('/about.html').body.chomp.must_equal 'about'
  end
  
  it 'should cache all files' do
    ['/', '/css/style.css', '/images/image.svg', 'about.html'].each do |path|
      @request.get(path).headers['Cache-Control'].must_equal 'public, max-age=3600'
    end
  end
  
  it 'should serve `404-html` for pages that aren\'t found' do
    res = @request.get '/path'
    res.body.chomp.must_equal '404'
    res.status.must_equal 404
  end
end

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
  
  describe 'when requesting the root directory' do
    before do
      @res = @request.get('/')
    end
    
    it 'should serve the index path' do
      @res.body.chomp.must_equal 'index'
    end
    
    it 'should return a valid status code, that is 200: OK or 304: Not Modified' do
      [200, 304].must_include @res.status
    end
  end
  
  describe 'when requesting the path of a subdirectory of the root directory' do
    before do
      @paths = {
        '/css/style.css'    => 'style',
        '/images/image.svg' => 'image',
        '/about.html'       => 'about'
      }
    end
    
    it 'should serve the contents of the paths' do
      @paths.each do |path, body|
        @request.get(path).body.chomp.must_equal body
      end
    end
    
    it 'should cache all responses for a an hour' do
      @paths.each do |path, body|
        @request.get(path).headers['Cache-Control'].must_equal 'public, max-age=3600'
      end
    end
  end
  
  describe 'when requesting a path that does not exist' do
    before do
      @res = @request.get('/path')
    end
    
    it 'should serve the contents of `404.html` if the file exists' do
      @res.body.chomp.must_equal '404'
    end
    
    it 'should return the status code 404: Not Found' do
      @res.status.must_equal 404
    end
  end
end

# myapp.rb
require 'sinatra'
require 'sinatra/respond_to'
require 'json'
require 'haml'

Sinatra::Application.register Sinatra::RespondTo

get '/' do
  haml :hello, :format => :html5
end

get '/hello/:name' do
  return_value = {:name => params[:name]}
  respond_to do |wants|
    wants.html { haml :hello, :locals => return_value }
    wants.json { return_value.to_json }
  end
end

get '/API/v1/:utterance' do
  send_file 'public/' + parse_utterance(params[:utterance]), :type => :png, :disposition => 'attachment'
end

get '/API/v2/:utterance' do
  content_type :json
  {:utterance => params[:utterance], :image => "#{request.scheme}://#{[request.host, request.port].join(':')}/#{parse_utterance(params[:utterance])}"}.to_json
end

def parse_utterance (u)
  case u
    when /test/i
      'images/rails.png'
    when /help/i
      'images/bar_page_0.png'
    when /tesla.*opportunity/i
      'images/bar_page_2.png'
    when /navigating/i
      'images/bar_page_3.png'
    when /show.*opportunity/i
      'images/bar_page_4.png'
    when /change.*closing.*date/i
      'images/bar_page_6.png'
    when /changing.*closing.*date/i
      'images/bar_page_7.png'
    when /changed.*closing.*date/i
      'images/bar_page_8.png'
    when /on.*track.*quota/i
      'images/bar_page_10.png'
    when /show.*quota/i
      'images/bar_page_11.png'
    else
      'images/bar_page_0.png'
  end
end
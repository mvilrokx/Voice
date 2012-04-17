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
  case params[:utterance]
    when /test/i
      send_file 'public/images/rails.png', :type => :png, :disposition => 'attachment'
      # Better to return URI of Image!!! + data
    when /help/i
      send_file 'public/images/bar_page_0.png', :type => :png, :disposition => 'attachment'
    when /tesla.*opportunity/i
      send_file 'public/images/bar_page_2.png', :type => :png, :disposition => 'attachment'
    when /navigating/i
      send_file 'public/images/bar_page_3.png', :type => :png, :disposition => 'attachment'
    when /show.*opportunity/i
      send_file 'public/images/bar_page_4.png', :type => :png, :disposition => 'attachment'
    #when //i
    #  send_file 'public/images/bar_page_5.png', :type => :png, :disposition => 'attachment'
    when /change.*closing.*date/i
      send_file 'public/images/bar_page_6.png', :type => :png, :disposition => 'attachment'
    when /changing.*closing.*date/i
      send_file 'public/images/bar_page_7.png', :type => :png, :disposition => 'attachment'
    when /changed.*closing.*date/i
      send_file 'public/images/bar_page_8.png', :type => :png, :disposition => 'attachment'
    #when //i
    #  send_file 'public/images/bar_page_9.png', :type => :png, :disposition => 'attachment'
    when /on track.*quota/i
      send_file 'public/images/bar_page_10.png', :type => :png, :disposition => 'attachment'
    when /show.*quota/i
      send_file 'public/images/bar_page_11.png', :type => :png, :disposition => 'attachment'
    else
      send_file 'public/images/bar_page_0.png', :type => :png, :disposition => 'attachment'
  end
end
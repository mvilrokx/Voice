# myapp.rb
require 'sinatra'
require 'sinatra/respond_to'
require 'json'
require 'haml'
require 'active_support'
require "base64"
require 'dalli'

# memcache configuration
set :cache, Dalli::Client.new
set :enable_cache, true
set :days_30, 2592000

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
  reply = parse_utterance(params[:utterance])
  send_file 'public/' + reply[:img], :type => :png, :disposition => 'attachment'
end

get '/API/v2' do
  content_type :json
#  return_data(params[:utterance])
  return_data(params)
end

#def return_data(key, time_to_live=settings.days_30)
def return_data(p, time_to_live=settings.days_30)
  key = [p[:utterance],p[:state]].join
  if !settings.enable_cache 
    return answer(key)
  end

  if settings.cache.get(key) == nil
    settings.cache.set(key, answer(p), ttl=time_to_live)
    puts "Cache Miss!"
  end
 
  return settings.cache.get(key)

end

def answer(p)
  reply = parse_utterance(p)
  {:reply => reply[:reply],
   :image_url => ("#{request.scheme}://#{[request.host, request.port].join(':')}/#{reply[:img]}" if reply[:img]),
   :img_data => (Base64.encode64(File.read("public/#{reply[:img]}")).gsub("\n", '') if reply[:img])
  }.to_json
end

def parse_utterance(p = {})
  case p[:utterance]
    when /test/i
      {:img => 'images/rails.png', :reply => "test"}
    when /help/i
      {:img => 'images/bar_page_0.png', :reply => "how can i help you"}
    when /(do.*it|yes)/i      
      case p[:state]
        when "2"
          {:img => 'images/bar_page_4.png', :reply => ""}
        when "7"
          {:img => 'images/bar_page_8.png', :reply => ""}
        when "10"
          {:img => 'images/bar_page_11.png', :reply => ""}
        else
          {:img => nil, :reply => ""}
      end
    when /tesla.*opportunity/i
      {:img => 'images/bar_page_2.png', :reply => "go to tesla motors opportunity. should i do it?"}
    when /navigating/i
      {:img => 'images/bar_page_3.png', :reply => ""}
    when /show.*opportunity/i
      {:img => 'images/bar_page_4.png', :reply => ""}
    when /change.*closing.*date/i
      {:img => 'images/bar_page_6.png', :reply => "changing the closing date to january 15th 2013. should i do it?"}
#    when /changing.*closing.*date/i
#      {:img => 'images/bar_page_7.png', :reply => ""}
    when /changed.*closing.*date/i
      {:img => 'images/bar_page_8.png', :reply => ""}
    when /on.*track.*quota/i
      {:img => 'images/bar_page_10.png', :reply => "am i on track to hit my quota? should I find out?"}
    when /show.*quota/i
      {:img => 'images/bar_page_11.png', :reply => ""}
    else
      {:img => nil, :reply => ""}
  end
end
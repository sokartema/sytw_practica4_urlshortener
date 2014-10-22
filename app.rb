#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'uri'
require 'pp'
require 'omniauth-twitter'
#require 'socket'
require 'data_mapper'
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['gidentifier'], config['gsecret'],
  {
     :authorize_params => {
        :force_login => 'true'
      }
    }
	provider :twitter, config['tidentifier'], config['tsecret'],
  {
     :authorize_params => {
        :force_login => 'true'
      }
    }
end


DataMapper.setup( :default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/my_shortened_urls.db" )
DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true

require_relative 'model'

DataMapper.finalize

#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

Base = 36

enable :sessions
set :session_secret, '*&(^#234a)'

get '/' do
  @user = nil
  puts "inside get '/': #{params}"
  @list = ShortenedUrl.all(:order => [ :id.asc ], :email => nil ,:limit => 20)
  # in SQL => SELECT * FROM "ShortenedUrl" ORDER BY "id" ASC
  haml :index
end

post '/' do
  puts "inside post '/': #{params}"
  uri = URI::parse(params[:url])
  opcional = params[:opcional]
  if uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS then
    begin
      @short_url = ShortenedUrl.first_or_create(:url => params[:url] , :opcional => params[:opcional])
    rescue Exception => e
      puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
      pp @short_url
      puts e.message
    end
  else
    logger.info "Error! <#{params[:url]}> is not a valid URL"
  end
  redirect '/'
end

get '/:shortened' do
  puts "inside get '/:shortened': #{params}"
  short_url = ShortenedUrl.first(:id => params[:shortened].to_i(Base))

  redirect short_url.url, 301
end

get '/auth/:name/callback' do
  config = YAML.load_file 'config/config.yml'
  case params[:name]
  when 'google_oauth2'
	  @auth = request.env['omniauth.auth']
	  session[:name] = @auth['info'].name
	  session[:email] = @auth['info'].email
	  redirect "/user/google"
  when 'twitter'
	  @auth = request.env['omniauth.auth']
	  session[:name] = @auth['info'].name
	  session[:nickname] = @auth['info'].nickname	
      redirect "/user/twitter"	  	
  else
  redirect "/"
  end

end

get '/user/:webname' do

  if (session[:name] != nil)

  case(params[:webname])
  when "google"
	  @user = session[:name]
	  email = session[:email]
	  @list = ShortenedUrl.all(:order => [ :id.asc ], :email => nil, :limit => 20)
	  @list2 = ShortenedUrl.all(:order => [:id.asc], :email => email , :email.not => nil, :limit => 20)
	  haml :google
  
  when "twitter"
		@user = session[:name]
	  	nickname = session[:nickname]
	  	@list = ShortenedUrl.all(:order => [ :id.asc ], :email=>nil, :nickname => nil, :limit => 20)
	  	@list2 = ShortenedUrl.all(:order => [:id.asc], :nickname => nickname , :email=>nil, :nickname.not => nil, :limit => 20)

		haml :twitter
  else
  	haml :index
  end

  else

  redirect '/'
  end


end

post  '/user/:webname' do

  if (session[:name] != nil)

  uri = URI::parse(params[:url])
  if uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS then
    begin
      @short_url = ShortenedUrl.first_or_create(:url => params[:url] , :email => flash[:email] , :opcional => params[:opcional])
    rescue Exception => e
      puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
      pp @short_url
      puts e.message
    end
  else
    logger.info "Error! <#{params[:url]}> is not a valid URL"
  end
  redirect '/user/google'

  else

  redirect '/'
  end
end

get '/user/:webname/logout' do

  session.clear

  redirect '/'

end

error do haml :index end

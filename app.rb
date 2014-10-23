#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'uri'
require 'pp'
require 'omniauth-twitter'
require 'data_mapper'
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'omniauth-facebook'

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
  provider :facebook, config['fidentifier'], config['fsecret'],
    :scope => 'email, public_profile', :auth_type => 'reauthenticate'

end


DataMapper.setup( :default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/my_shortened_urls.db" )
DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true

require_relative 'model'

DataMapper.finalize

#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

use Rack::MethodOverride

Base = 36

enable :sessions
set :session_secret, '*&(^#234a)'

get '/' do
  @user = nil
  @webname = nil
  puts "inside get '/': #{params}"
  @list = ShortenedUrl.all(:order => [ :id.asc ], :email => nil , :nickname => nil).shuffle.slice(0..2)

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

  short_url = ShortenedUrl.first(:id => params[:shortened].to_i(Base))

  redirect short_url.url, 301
end

get '/u/:shortened' do

  short_url = ShortenedUrl.first(:opcional => params[:shortened])

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
  when 'facebook'
    @auth = request.env['omniauth.auth']
    session[:name] = @auth['info'].name
    session[:email] = @auth['info'].email
    redirect "/user/facebook"
  else
  redirect "/"
  end

end

get '/user/:webname' do

  if (session[:name] != nil)

  @webname = params[:webname]

  case(params[:webname])
  when "google"
	  @user = session[:name]
	  email = session[:email]
	  @list = ShortenedUrl.all(:order => [ :id.asc ], :email => nil , :nickname => nil).shuffle.slice(0..2)
	  @list2 = ShortenedUrl.all(:order => [:id.asc], :email => email , :email.not => nil, :limit => 20)
	  haml :google

  when "twitter"
		@user = session[:name]
	  	nickname = session[:nickname]
	  	@list = ShortenedUrl.all(:order => [ :id.asc ], :email=>nil, :nickname => nil).shuffle.slice(0..2)
	  	@list2 = ShortenedUrl.all(:order => [:id.asc], :nickname => nickname , :email=>nil, :nickname.not => nil, :limit => 20)

		haml :twitter
  when "facebook"

    @user = session[:name]
    email = session[:email]
    @list = ShortenedUrl.all(:order => [ :id.asc ], :email => nil, :nickname => nil).shuffle.slice(0..2)
    @list2 = ShortenedUrl.all(:order => [:id.asc], :email => email , :email.not => nil, :limit => 20)
    haml :facebook

  else
  	haml :index
  end

  else

  redirect '/'
  end


end

post  '/user/:webname' do

  uri = URI::parse(params[:url])
  if uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS then

  case(params[:webname])
  when "google"

    begin
      @short_url = ShortenedUrl.first_or_create(:url => params[:url] , :email => session[:email] , :opcional => params[:opcional])
    rescue Exception => e
      puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
      pp @short_url
      puts e.message
    end

  redirect '/user/google'

  when "twitter"

    begin
      @short_url = ShortenedUrl.first_or_create(:url => params[:url] , :nickname => session[:nickname] , :opcional => params[:opcional])
    rescue Exception => e
      puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
      pp @short_url
      puts e.message
    end

    redirect '/user/twitter'

  when "facebook"

      begin
        @short_url = ShortenedUrl.first_or_create(:url => params[:url] , :email => session[:email] , :opcional => params[:opcional])
      rescue Exception => e
        puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
        pp @short_url
        puts e.message
      end

    redirect '/user/facebook'

  else

  redirect '/'
  end

  else
    logger.info "Error! <#{params[:url]}> is not a valid URL"
  end

end

get '/user/:webname/logout' do

  session.clear

  redirect '/'

end

delete '/delete/:webname/:url' do

  case (params[:webname])
    when 'google'
      begin
      @id = ShortenedUrl.first(:email => session[:email], :opcional => params[:url])
      @id.destroy if !@id.nil?
      rescue Exception => e
        puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
        pp @short_url
        puts e.message
      end
      redirect '/user/google'
    when 'twitter'
      begin
      @id = ShortenedUrl.first(:nickname => session[:nickname], :opcional => params[:url])
      @id.destroy if !@id.nil?
      rescue Exception => e
        puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
        pp @short_url
        puts e.message
      end
      redirect '/user/twitter'
    when 'facebook'
      begin
      @id = ShortenedUrl.first(:email => session[:email], :opcional => params[:url])
      @id.destroy if !@id.nil?
      rescue Exception => e
        puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
        pp @short_url
        puts e.message
      end
      redirect '/user/facebook'

    when 'googleid'
        begin
        @id = ShortenedUrl.first(:email => session[:email], :id => params[:url].to_i(Base))
        @id.destroy if !@id.nil?
        rescue Exception => e
          puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
          pp @short_url
          puts e.message
        end
        redirect '/user/google'
      when 'twitterid'
        begin
        @id = ShortenedUrl.first(:nickname => session[:nickname], :id => params[:url].to_i(Base))
        @id.destroy if !@id.nil?
        rescue Exception => e
          puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
          pp @short_url
          puts e.message
        end
        redirect '/user/twitter'
      when 'facebookid'
        begin
        @id = ShortenedUrl.first(:email => session[:email], :id => params[:url].to_i(Base))
        @id.destroy if !@id.nil?
        rescue Exception => e
          puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
          pp @short_url
          puts e.message
        end
        redirect '/user/facebook'
    else

      redirect '/'
  end

end

error do haml :index end

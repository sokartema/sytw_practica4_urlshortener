#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'uri'
require 'pp'
#require 'socket'
require 'data_mapper'
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['gidentifier'], config['gsecret']
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
  @list = ShortenedUrl.all(:order => [ :id.asc ], :limit => 20)
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
  @auth = request.env['omniauth.auth']
  nombre = @auth['info'].name
  nombre.gsub!(/\s+/, "")
  hash = {:info => @auth['info']}
  hash[:credentials] = @auth['credentials']
  redirect "/"

end

error do haml :index end

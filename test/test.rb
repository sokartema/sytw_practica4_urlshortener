# -*- coding: utf-8 -*-

ENV['RACK_ENV'] = 'test'
require_relative '../app.rb'
require 'test/unit'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "Tests de la pagina raiz ('/') con metodo get" do

it "Carga de la web desde el servidor" do
  get '/'
  assert last_response.ok?
end

end

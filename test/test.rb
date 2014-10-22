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
	before :all do
		@imagen="/logo/logo.png"
		@textoTitulo="<title>Inicio</title>"
		@textoCabecera="Twitter Most Popular Friend"
		@textoContenido="NºAmigos a mostrar (max 10)"
		@css="/public/css/lavish-bootstrap.css"
	end

	it "Carga de la web desde el servidor" do
	  get '/'
	  assert last_response.ok?
	end
	it "Comprueba el titulo de la pagina" do
		get '/'
		assert last_response.body.include?(@textoTitulo), "El titulo tiene que ser: "+@textoTitulo
	end

	it "Comprueba que en la pagina hay una cabecera Most Popular Twitter Friend" do

		get '/'
		assert last_response.body.include?(@textoCabecera), "El titulo de cabecera tiene que estar en el contenido"

	end

	it "Comprueba el contenido del cuadro de texto" do
		get '/'
		assert last_response.body.include?(@textoContenido), "El contenido tiene que estar en la web"
	end

	it "Comprueba el mensaje en el campo de visualizacion de amigos" do
		get '/'
		assert last_response.body.include?("No se ha introducido ningun usuario o es incorrecto"), "Tiene que haber un mensaje informativo"

	end	
	
	it "Comprueba la carga del logo de la web" do
		get '/'
		assert last_response.body.include?("/icons/"+@imagen), "Debe tener el logo de la web" 
	end

	it "Comprueba si esta el CSS en el servidor" do

		path = File.absolute_path(__FILE__)
		path=path+@css
		path=path.split('/test/test.rb')
		path=path[0]+path[1]

		assert File.exists?(path), "Debe estar el CSS en el servidor"
	end

end

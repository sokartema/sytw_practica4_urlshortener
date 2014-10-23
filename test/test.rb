# -*- coding: utf-8 -*-

ENV['RACK_ENV'] = 'test'
require_relative '../app.rb'
require 'test/unit'
require 'minitest/autorun'
require 'rack/test'
require 'selenium-webdriver'


include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "Tests de la pagina raiz principal ('/') con metodo get" do
	before :all do
		@imagen="/public/logo/logo.png"
		@textoTitulo="<title>Inicio</title>"
		@textoCabecera="Practica URL Shortener"
		@textoContenido="Acorta tu URL"
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

	it "Comprueba que en la pagina hay una cabecera" do

		get '/'
		assert last_response.body.include?(@textoCabecera), "El titulo de cabecera tiene que estar en el contenido"

	end

	it "Comprueba el contenido del cuadro de texto" do
		get '/'
		assert last_response.body.include?(@textoContenido), "El contenido tiene que estar en la web"
	end
	
	it "Comprueba la carga del logo en el public del servidor" do
		path = File.absolute_path(__FILE__)
		path=path+@imagen
		path=path.split('/test/test.rb')
		path=path[0]+path[1]

		assert File.exists?(path), "Debe estar la imagen en public"

	end

	it "Comprueba si esta el CSS en el servidor" do

		path = File.absolute_path(__FILE__)
		path=path+@css
		path=path.split('/test/test.rb')
		path=path[0]+path[1]

		assert File.exists?(path), "Debe estar el CSS en el servidor"
	end

end

describe "Test de la paginas paginas de login" do
	before :all do
		@pagina='/usr/google'
		@pagina2='/usr/twitter'
		@pagina3='/usr/facebook'

	end


	it "Entrar en la pagina #{@pagina} sin loguearse" do	

		get @pagina
		respuesta=last_response.ok?
		assert(not(respuesta))
		
	end
	
	it "Entrar en la pagina #{@pagina2} sin loguearse" do	

		get @pagina2
		respuesta=last_response.ok?
		assert(not(respuesta))
		
	end

	it "Entrar en la pagina #{@pagina3} sin loguearse" do	

		get @pagina3
		respuesta=last_response.ok?
		assert(not(respuesta))
		
	end	
end


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


describe "Test de la paginas de login" do
	before :all do
		@pagina='/usr/google'
		@pagina2='/usr/twitter'
		@pagina3='/usr/facebook'
		@textocontenido="Una sola cuenta de Google para todos los servicios de Google"
		@textocontenido3='Entrar en Facebook'
		@textocontenido2='Condiciones de Servicio de Twitter'

	end

	it "Logueo de Google" do

		browser = Selenium::WebDriver.for :firefox
		browser.get('localhost:9292')
		browser.manage.timeouts.implicit_wait=3
		element=browser.find_element :id => "googleboton"
		element.click
		browser.manage.timeouts.implicit_wait=3

		body_element = browser.find_element(:tag_name => "body")
		body_element=body_element.text.to_s
		
		value=false
		if body_element.include? "Una sola cuenta de Google para todos los servicios de Google"
			value=true
		end
		assert (value)
		browser.close()

	end

	it "Logueo de Twitter" do

		browser = Selenium::WebDriver.for :firefox
		browser.get('localhost:9292')
		browser.manage.timeouts.implicit_wait=3
		element=browser.find_element :id => "twitterboton"
		element.click
		browser.manage.timeouts.implicit_wait=3

		body_element = browser.find_element(:tag_name => "body")
		body_element=body_element.text.to_s
		
		value=false
		if body_element.include? "Condiciones de Servicio de Twitter"
			value=true
		end
		assert (value)
		browser.close()
	end
	it "Logueo de Facebook" do

		browser = Selenium::WebDriver.for :firefox
		browser.get('localhost:9292')
		browser.manage.timeouts.implicit_wait=3
		element=browser.find_element :id => "facebookboton"
		element.click
		browser.manage.timeouts.implicit_wait=3
		body_element = browser.find_element(:tag_name => "body")
		body_element=body_element.text.to_s
		
		value=false
		if body_element.include? "Entrar en Facebook"
			value=true
		end
		assert (value)
		browser.close()
	end
	
end


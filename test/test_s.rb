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


describe "Test de la paginas paginas de login" do
	before :all do
		@pagina='/usr/google'
		@pagina2='/usr/twitter'
		@pagina3='/usr/facebook'

	end

	it "Logueo de Google" do

		browser = Selenium::WebDriver.for :firefox
		browser.get('localhost:9292')
		browser.manage.timeouts.implicit_wait=3
		element=browser.find_element :id => "googleboton"
		element.click
		browser.manage.timeouts.implicit_wait=3
		browser.close()

		#element.click
	end
	it "Logueo de Twitter" do

		browser = Selenium::WebDriver.for :firefox
		browser.get('localhost:9292')
		browser.manage.timeouts.implicit_wait=3
		element=browser.find_element :id => "twitterboton"
		element.click
		browser.manage.timeouts.implicit_wait=3
		browser.close()
	end
	it "Logueo de Facebook" do

		browser = Selenium::WebDriver.for :firefox
		browser.get('localhost:9292')
		browser.manage.timeouts.implicit_wait=3
		element=browser.find_element :id => "facebookboton"
		element.click
		browser.manage.timeouts.implicit_wait=3
		browser.close()
	end
	
end


# URL shortener [![Build Status](https://travis-ci.org/alu0100595727/sytw_practica4_urlshortener.svg?branch=master)](https://travis-ci.org/alu0100595727/sytw_practica4_urlshortener)

![logo](http://i1377.photobucket.com/albums/ah55/Jazer_Abreu/logo_zps1d404711.png)

Aplicacion para la creacion de links acortados de paginas webs y su almacenamiento. El logueo se podra realizar mediante la autentificacion de Facebook, Google o Twitter, ademas de permitir el uso anonimo de la misma.

El usuario logueado almacenara sus links, y ademas tendra la posibilidad de añadir el nombre de la url, ademas de borrarlos de su lista si lo cree necesario. Para ir a un link en concreto, seleccionelo en la lista o pon en la url /u/ y el opcional del link.

Este proyecto ha sido implementado para el despliegue en heroku y contiene tests con seguimiento en travis.

Proyecto en Heroku: [LINK!](http://urlsytw.herokuapp.com)

### Status
Tecnologias usadas:
* [DataMapper](http://datamapper.org/getting-started.html)
* [Haml](http://haml.info/)
* [Sinatra](http://www.sinatrarb.com/)
* [Deploying Rack-based Apps in Heroku](https://devcenter.heroku.com/articles/rack)
* [Intridea Omniauth](https://github.com/intridea/omniauth)
* [Selenium](http://www.seleniumhq.org/)

### Modo de uso

Antes de iniciar el servidor ejecutar `bundle install` o `rake bundle`

Si hay problemas al hacer bundle install, debemos hacer lo siguiente:

En MAC:

Abrir una terminal y si tenemos instalado homebrew, ejecutar `brew install postgresql`

En Linux:

Ejecutar: `sudo apt-get install postgresql`

Si sigue sin funcionar instalar lo siguiente:

`sudo apt-get install -qq postgresql-server-dev-9.3`

`sudo apt-get install -qq libpq-dev`

Para arrancar el servidor situese en el directorio y ejecute `rackup`,`rake init` o `rake rackup` luego abra un navegador y vaya a la direccion localhost:9292

Para arrancar los test ejecutar `rake test` o simplemente `rake`, para arrancar los test con selenium ejecute `rake selenium`

Para ver todas las opciones disponibles en Rake ejecute `rake -T`

**Jazer Abreu -> alu0100595727**

**Javier Clemente -> alu0100505023**

Sistemas y Tecnologias Web, ETSII, Universidad de la Laguna.

![ULL](http://www.ull.es/Public/images/wull/logo.gif)

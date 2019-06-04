# Nokogiri Demo

Instalar dependencias:

    $ bundler install

Ejecutar aplicación:

    $ ruby app.rb

### Instrucciones Base de Datos

Descargar de fuentes[1] la base de datos y luego descomprimir. Luego entrar por el cmd a la carpeta para poder ejecutar los siguientes códigos según sea necesario.

Arrancar base de datos:

	>  bin\mysqld --console --port=1234

Para dumpear la base de datos:

	> mysqldump -u root -p almacenes > db/almacenes.sql --port=1234

Para restablecer la base de datos:

	> mysql -u root -p almacenes < db/almacenes.sql --port=1234

### DML de la Base de Datos

MySQL:

```
    CREATE SCHEMA noko;
    USE noko;
    CREATE TABLE videos(
        id INT PRIMARY KEY AUTO_INCREMENT,
        link TEXT,
        duration TEXT,
        image TEXT,
        name TEXT,
        views TEXT,
        author TEXT);
```

---

Fuentes:

+ https://downloads.mariadb.org/interstitial/mariadb-10.3.14/winx64-packages/mariadb-10.3.14-winx64.zip/from/http%3A//mirror.upb.edu.co/mariadb/?serve
+ https://nokogiri.org/
+ https://github.com/jnunemaker/httparty
+ http://ruby.bastardsbook.com/chapters/html-parsing/
+ https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Element
+ https://stackoverflow.com/questions/4190797/how-can-i-remove-the-string-n-from-within-a-ruby-string
+ https://github.com/pepeul1191/ruby-accesos-v2
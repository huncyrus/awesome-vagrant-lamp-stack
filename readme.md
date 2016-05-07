# Awesome LAMP stack for Vagrant by huncyrus

System independent development environment for real world projects. This package is ideal for start a project where composer and lamp will be the basics.

### Table of content
 - [Main features](#main)
 - [System requirements](#system)
 - [Structure from outside](#structure)
 - [Structure at inside](#structure2)
 - [Usage](#usage)
 - [Under the hood... what is inside?](#underthehood)
 - [Credits](#credits)
 - [License](#license)
 - [Future features... ](#future)

<a name="main" />
### Main features
    - LAMP Stack
        - Ubuntu Linux 14.04LTS, x64, Server edition
        - Apache2
        - MySQL
        - PHP
    - Fancy extra modules for real-world projects (Check "Under the hood" section for it)



<a name="system" />
### System requirements
 - Minimum
    - Some modern CPU preferably minimum with 2 core
    - 3 GB memory (1 goes for virtual machine)
    - 5 GB storage
 - Optimal
    - CPU: with 4 core
    - 8 GB memory
    - 10 GB storage on SSD

<a name="structure" />
#### Structure & Parts from outside:
    - "doc" Folder for documentation
    - "myProject" folder for working files
    - "vagrant" folder for vagrant setup files
    - "readme.md" what you read right now


<a name="usage" />
### Usage
##### 1.) Install pre-requisities
    - VirtualBox 5+
    - Vagrant (latest)
    - Some shell (on mac and linux terminal fine, on windows use SmartGit Gui Bash please)
    - Git (optional)

##### 2.) Change vagrantbox configuration if needed
    - You could change the vagrant box:
        - Memory usage (ram what associated to the box)
        - CPU amount
    - Project folder name
    - Passwords for services inside vagrant & bootstrap sql, like mysql, phpmyadmin

##### 3.) Install the developer environment
    - cd vagrant
    - vagrant up

At first run it will take a while and show lot of line and message. At the very end, you should able to use the development
env in your browser (by default is ***192.168.33.22***) and in command line.


##### 4.) Add files into myProject folder
    - Use composer to add libs, frameworks or modules
        - Example: composer require "slim/slim"
        - For packages check http://www.packagist.com please
    - Use composer autoload and composer.json file as well
    - Please use composer based autoload file (vendor/autoload.php) in your project


##### 5.) Database remote control
    - For database config, use this:
        - HOST: localhost
        - PORT: 3306 (standard, default)
        - USER: root
        - PASS: root (or what you give it in bootstrap.sh file)
    - For connection use SSH tunneling
        - IP/Proxy IP the vagrantbox ip, by default is 192.168.33.22
        - User: vagrant
        - Password: vagrant

<a name="structure2" />
### "Structure @ Inside"
 - File structure:
    - /app - MVC & PHP Libs
    - /public - CSS, JS, Images
    - /vendor - Composer will install here all dependency
    - .htaccess - The main re-writer for nice urls
    - composer.json - Package file
    - index.php - Main init


<a name="underthehood" />
### Under the hood
##### System:
    - Ubuntu 14.04LTS, x64, Server
    - No GUI
    - Extra modules:
        - cUrl
        - Midnight Commander
        - hTop
        - Aptitude
        - OpenSSL
        - NFS packages (common, kernel-server)
##### Programming stuffs
    - PHP 5.6 (you can change the settings for 5.5 or for 7.0)
        - Config
            - Error log by default
            - OpCache disabled
            - APC disabled
        - Libraries
            - GD
            - ImageMagick
            - IconV
            - Redis
            - xDebug
            - APC
            - OpCache
            - MongoDb
            - mCrypt
            - xmlRpc
        - Extra
            - php Mass Detector
            - php Code Sniffer
    - Python
    - Ruby 2+
        - Rails
        - Gems
    - NodeJS
    - C++11 (gcc)
##### Server related
    - Apache2
        - mod_rewrite enabled
        - Working directory setted up (/myProject/ << /var/www/html/)
##### Database related
    - Mysql 5.5
    - Redis
    - MongoDB
    - SqLite
##### Message Quening
    - Beanstalkd
    - RabbitMQ
##### Package controller / Dependency Managers
    - Composer
    - NPM
##### Caching
    - Memcache
    - Memcached
    - Redis
##### Other
    - MailCatcher
    - PhpMyAdmin
    - Gulp
    - Grunt
    - Bower
    - Git
    - Sass
    - Compass



<a name="credits" />
### Credits
 - Author: Györk "huncyrus" Bakonyi 2016
 - http://www.github.com/huncyrus

<a name="license" />
### License
 - MIT License

<a name="future" />
### Future features
 - [x] MailCatcher addon
 - [x] xDebug addon with full config (for phpStorm)
 - [ ]nGinx addon
 - [ ]Heroku and other version control, deploy and dev related addon
 - [ ]Postgres and MariaDB addon
 
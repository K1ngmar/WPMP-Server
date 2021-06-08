# WPMP-Server ✂️
A Worpress, Mysql, phpmyadmin stack running on our own webserver [Plebserv](https://github.com/K1ngmar/Plebserv)

## Installation 📥

Clone the repo, `git clone https://github.com/K1ngmar/WPMP-Server.git`

## Run the server 🖥

```sh
docker build -t WPMP-Server .
docker run -p 80:80 WPMP-Server
```

## Usage 📈

By default the server runs on localhost:80

- localhost redirects to wordpress
- localhost/phpMyAdmin redirects to phpMyAdmin

[note] the server works with maria-db

## Login 🔒

Login details by default: `UID="admin" PWD="admin"`

## Shout out 💯
* [@Alpha_1337k](https://github.com/Alpha1337k)
* [@VictorTennekes](https://github.com/VictorTennekes)

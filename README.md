# ERP SYSTEM

## Deploy Steps
```
HANAMI_ENV=production hanami assets precompile
```
```
docker pull ducd/coreapp
```
```
docker run -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 --name db postgres
```
```
docker run -d --link db:db -p 2300:2300 ducd/coreapp bundle exec hanami server
```


## Build Steps
```
docker build .
```
```
docker tag [image_id] ducd/coreapp:latest
```
```
docker push ducd/coreapp
```


## Setup new server
###run docker without sudo on linux
```
add docker group
```
```
sudo groupadd docker
```
```
add current user to docker group
```
```
sudo gpasswd -a $USER docker
```
```
newgrp docker
```

## Testing command line on production

## HEROKU command lines
```
heroku logs --tail
```
```
heroku run hanami console HANAMI_ENV=production
```
```
heroku run rake db:migrate
```
### heroku deploy app
```
git push heroku master
```

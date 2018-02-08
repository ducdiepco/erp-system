HANAMI_ENV=production hanami assets precompile
docker run -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 --name db postgres
docker run -d --link db:db -p 2300:2300 ducd/coreapp bundle exec hanami server

docker pull ducd/coreapp


Push step
docker build .
docker tag image_id ducd/coreapp:latest
docker push ducd/coreapp


Setup new server
run docker without sudo on linux

add docker group
sudo groupadd docker

add current user to docker group
sudo gpasswd -a $USER docker
newgrp docker


testing command line on production

ssh ubuntu@34.213.50.44

curl -d "customer_id=509319175&amount=100&is_type=payline-1" http://34.213.50.44/payment-api/payments/create-charge
curl -d "customer_id=509319175&amount=100&is_type=payline-1" http://localhost:2300/payment-api/payments/create-charge

curl -d "card_number=4111111111111111&card_month=10&card_year=2020&card_cvc=123&first_name=test_first_name&last_name=last_name&email=email@email.com&is_type=payline-1" http://34.213.50.44/payment-api/payments/create-customer
curl -d "card_number=4111111111111111&card_month=10&card_year=2020&card_cvc=123&first_name=test_first_name&last_name=last_name&email=email@email.com&is_type=payline-1" http://localhost:2300/payment-api/payments/create-customer

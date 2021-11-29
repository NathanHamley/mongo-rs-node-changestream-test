# Example mongo db change stream + node 

## 1 Build custom mongo container:
eg:
```
docker build -t "mongors:test" .
```

## 2 a) Run container standalone
docker run -e MONGO_INITDB_ROOT_USERNAME=test -e MONGO_INITDB_ROOT_PASSWORD=secure -e MONGO_HOSTNAME=localhost -e MONGODB_PORT=27017

note: this is not tested

## 2b) run with docker compose, containing mongo-express
This allows you to also create documents and stuff, to test that it is working
this may require multiple startups:
```
docker-compose up -d 
```
wait 10 seconds
```
docker-compose up 
```
this will bind the console to the second up.

navigate to http://localhost:8888
login using the values set in docker-compose.yaml (admin:admin is the default)
create a database called test.
select the database
create a collection called test_coll

open a new terminal

run the following 2 commands
```
npm i 
```
```
npm run start 
```

change things on the database (e.g create a new document, delete one) and events should show up in the console
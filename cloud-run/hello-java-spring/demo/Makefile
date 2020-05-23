
help:
	cat Makefile

curl:
	curl http://localhost:8080/

run: build
	./mvnw

run2: build
	mvn spring-boot:run

install:
	sudo apt-get install maven default-jdk
	mvn install

build:
	mvn compile
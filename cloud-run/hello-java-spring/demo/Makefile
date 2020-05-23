
help:
	cat Makefile

curl:
	curl http://localhost:8080/

run: 
	./mvnw

run2: 
	mvn spring-boot:run

# https://cwiki.apache.org/confluence/display/MAVEN/NoGoalSpecifiedException
install:
	sudo apt-get install maven default-jdk
	mvn install
	mvn compiler:compile

build:
	mvn compile
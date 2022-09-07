# Running the Hello World Example

---
### Prerequisites
- Install Maven Version 3.8.6 
  - OS X: `brew install maven`
- Install Spring Version 2.7.3 and Spring Boot
  - OS X: `brew tap spring-io/tap`
  - OS X: `brew install spring-boot`
- Install Java 18 and JDK
  - https://www.oracle.com/java/technologies/downloads/

### Running the example
- Maven uses pom.xml to build / run projects, so commands need to be executed from the directory containing this.
- Inside this folder run `mvn spring-boot:run`
- Visit localhost:8080 to see the hello world output (might clash with the Docker port)

### Packaging as a JAR
- Run `mvn package` from the command line in the api folder
- Inside target directory will find file output called similar to: `api-x.x.x-SNAPSHOT.jar`
- To run the jar use the JAR command:
  - `java -jar target/api-0.0.1-SNAPSHOT.jar`
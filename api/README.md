# API Definition

## Employee 

`GET/employees` - Find all employees in table
* Parameter Content Type: Application/JSON
* Example Request:
  * `GET http://ec2-endpoint.com:8081/employees/`

`GET/employees/{employeeId}` - Find employee by ID
* Parameter Content Type: Application/JSON
* Example Request:
  * `GET http://ec2-endpoint.com:8081/employees/1`

`PUT/employees/{employeeId}?params` - Update an existing employee
* Parameter Content Type: Application/JSON
* Example Request:
  * `PUT http://ec2-endpoint.com:8081/employees/1?name=Aaron&email=aarongrill@gmail.com`

`POST/employees` - Add a new employee to the table
* Parameter Content Type: Application/JSON
* Example Request:
  * `{
    "name": "aaron",
    "email": "aaron@gmail.com",
    "dob": "2000-01-01"
    }`

`DELETE/employees/{employeeId}` - Deletes an employee
* Parameter Content Type: Application/JSON
* Example Request:
  * `DELETE http://ec2-endpoint.com:8081/employees/1`

## Running the Hello World Example Directly

---
### Prerequisites
- Install Maven Version 3.8.6
    - OS X: `brew install maven`
    - Other: Follow `https://maven.apache.org/install.html`
- Install Spring Version 2.7.3 and Spring Boot
    - OS X: 
      - `brew tap spring-io/tap`
      - `brew install spring-boot`
    - Other:
      - Dependencies should be automatically downloaded by Maven when attempting to run the application

### Running the example
- Maven uses pom.xml to build / run projects, so commands need to be executed from the directory containing this.
- Inside this folder run `mvn spring-boot:run`
- Visit localhost:8080 to see the hello world output (might clash with the Docker port)

### Packaging as a JAR
- Run `mvn package` from the command line in the api folder
- Inside target directory will find file output called similar to: `api-x.x.x-SNAPSHOT.jar`
- To run the jar use the JAR command:
    - `java -jar target/api-0.0.1-SNAPSHOT.jar`


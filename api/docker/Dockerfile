FROM openjdk:18-alpine
WORKDIR /opt/app
# ARG JAR_FILE=target/api-0.0.1-SNAPSHOT.jar

# Use below when running using CircleCI
ARG JAR_FILE=api/target/api-0.0.1-SNAPSHOT.jar

# cp api-0.0.1-SNAPSHOT.jar /opt/app/app.jar
COPY ${JAR_FILE} app.jar

# java -jar /opt/app/app.jar
ENTRYPOINT ["java","-jar","app.jar"]

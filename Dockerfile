# Multi-stage build for Maven projects
FROM maven:3.8.3-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src src
COPY mvnw .
COPY .mvn .mvn
RUN chmod +x ./mvnw
RUN ./mvnw clean package -DskipTests

# Runtime stage
FROM openjdk:17-jdk
VOLUME /tmp
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
EXPOSE 8080
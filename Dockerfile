# Use Maven + JDK17 image to build
FROM maven:3.9.4-eclipse-temurin-17 AS build

WORKDIR /app

# Copy POM and sources
COPY pom.xml .
COPY src ./src

# Build jar
RUN mvn clean package -DskipTests

# Run stage with JDK17 only
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=build /app/target/appium-java-mobile-automation-demo-1.0.0.jar app.jar

# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]

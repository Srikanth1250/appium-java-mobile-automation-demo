# Use Maven with JDK 11
FROM maven:3.9.6-eclipse-temurin-11 AS builder

# Set work directory
WORKDIR /app

# Copy everything
COPY . .

# Optional: clean install without running tests
RUN mvn clean install -DskipTests

# Default command: run tests (you can override this with docker run)
CMD ["mvn", "test", "-Dplatform=android", "-Denv=dev"]

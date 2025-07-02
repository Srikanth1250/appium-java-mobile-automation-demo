# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy all project files
COPY . .

# Build the project
RUN mvn clean install -DskipTests

# Stage 2: Run tests if needed (or skip if only building)
CMD ["mvn", "test"]

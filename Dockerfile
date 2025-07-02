# Use an official Maven base image with Java 11
FROM maven:3.9.6-eclipse-temurin-11 as build

# Set working directory inside container
WORKDIR /app

# Copy all files into the container
COPY . .

# Build the project without running tests
RUN mvn clean install -DskipTests

# ---- Final Stage ----
FROM eclipse-temurin:11-jre

# Set working directory in final image
WORKDIR /app

# Copy the built project from the build stage
COPY --from=build /app .

# Default command to run TestNG tests (you can change profile: smoke-test, regression-test, etc.)
CMD ["mvn", "test", "-P", "smoke-test"]

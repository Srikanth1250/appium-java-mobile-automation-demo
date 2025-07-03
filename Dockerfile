# ---- Build Stage ----
FROM maven:3.9.6-eclipse-temurin-11 AS build

# Set working directory inside container
WORKDIR /app

# Copy all files into the container
COPY . .

# Download dependencies and build the project, skip tests
RUN mvn clean install -DskipTests

# ---- Final Stage (Runtime) ----
FROM maven:3.9.6-eclipse-temurin-11 AS runtime

# Set working directory
WORKDIR /app

# Copy the whole Maven project (for running test profiles)
COPY --from=build /app /app

# Run specific TestNG suite using profile (default: smoke-test)
CMD ["mvn", "test", "-P", "smoke-test"]

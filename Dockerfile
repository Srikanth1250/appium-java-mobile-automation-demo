# ====== BUILD STAGE ======
FROM eclipse-temurin:11-jdk as build

WORKDIR /app

# Copy project files
COPY . .

# Compile and skip tests
RUN ./mvnw clean compile -DskipTests || mvn clean compile -DskipTests

# ====== FINAL STAGE ======
FROM eclipse-temurin:11-jdk  # <-- use JDK, not JRE to compile/run successfully

WORKDIR /app

# Copy everything from build stage
COPY --from=build /app .

# Run TestNG suite by default (change profile as needed)
CMD ["mvn", "test", "-P", "smoke-test"]

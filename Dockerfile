# ------------ Stage 1: Build the project with Maven ------------
FROM maven:3.9.6-eclipse-temurin-11 AS build

# Set working directory
WORKDIR /app

# Copy everything to the container
COPY . .

# Build the Maven project (skip tests during build phase)
RUN mvn clean package -DskipTests \
    -Dmaven.compiler.showDeprecation=true \
    -Dmaven.compiler.showWarnings=true \
    -Dmaven.compiler.fork=true \
    -Dmaven.compiler.compilerArgs="--add-exports=jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED --add-opens=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED --add-opens=jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED"

# ------------ Stage 2: Runtime environment ------------
FROM eclipse-temurin:11-jdk

# Set working directory
WORKDIR /app

# Copy built application from previous stage
COPY --from=build /app .

# Install Maven CLI (optional: if you want to run tests inside container)
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Set env vars for compiler args (for Lombok to work if recompilation needed)
ENV MAVEN_OPTS="--add-exports=jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED --add-opens=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED --add-opens=jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED"

# Default: run smoke test suite (can override with docker run CMD)
CMD ["mvn", "test", "-P", "smoke-test"]

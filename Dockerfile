# Use a Maven base image with JDK 11 (or adjust to your project's needs)
FROM maven:3.9.6-eclipse-temurin-11

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the project files into the container
COPY . .

# Build the project (skip tests if needed)
RUN mvn clean compile -DskipTests

# Set default command (optional)
CMD ["mvn", "clean", "compile", "-DskipTests"]

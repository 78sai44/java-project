# Use an official OpenJDK runtime as the base image
FROM openjdk:17-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Java source file into the container
COPY helloworld.java /app/

# Compile the Java program
RUN javac HelloWorld.java

# Expose the port 
EXPOSE 6000

# Define the command to run the program
CMD ["java", "helloworld"]

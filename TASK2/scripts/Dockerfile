# Use an official Nginx runtime as a base image
FROM nginx:latest

# Set the working directory to the Nginx web root
WORKDIR /usr/share/nginx/html

# Copy website files into the container
COPY . .

# Expose port 80 for the web application (not strictly necessary for container-to-container communication)
EXPOSE 80

# Command to run the web application
CMD ["nginx", "-g", "daemon off;"]

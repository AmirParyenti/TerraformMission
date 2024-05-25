# Use the official NGINX image from Docker Hub
FROM nginx:latest

# Copy the static website to the nginx html directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 to the host
EXPOSE 80

# Start NGINX and ensure it stays running
CMD ["nginx", "-g", "daemon off;"]

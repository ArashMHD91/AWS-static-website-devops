# Use the official Nginx image as base
FROM nginx:alpine

# Copy the static website to Nginx's default serving directory
COPY index.html /usr/share/nginx/html/

# Copy a custom nginx configuration if needed
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# The default command starts Nginx
CMD ["nginx", "-g", "daemon off;"]
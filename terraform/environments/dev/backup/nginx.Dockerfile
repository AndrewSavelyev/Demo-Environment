# ------------ Nginx ------------
FROM nginx:1.27.3
# Copy the index.html with custom text
COPY index.html /usr/share/nginx/html/index.html
# Copy the Nginx config 
COPY default.conf /etc/nginx/conf.d/default.conf
# Grant permission on files and directories for the Nginx user
RUN chown -R nginx:nginx /etc/nginx/ && \
    chown -R nginx:nginx /var/cache/nginx  && \
    touch /run/nginx.pid  && \
    chown -R nginx:nginx /run/nginx.pid  && \
    chown -R nginx:nginx /var/log/nginx  && \
    chown -R nginx:nginx /usr/share/nginx
# Install ps
RUN apt-get update && apt-get install procps -y
# Create the default user
USER nginx
# Expose the Nginx port
EXPOSE 8080

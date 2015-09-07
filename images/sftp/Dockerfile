FROM atmoz/sftp@sha256:ccdfdfba84cdd4222249d267e50b5e49a9556b9ad605310ffcb0f0f392f63953

RUN mkdir -p /var/www/.ssh/keys

COPY keys/*.pub /var/www/.ssh/keys/

RUN chown -R www-data:www-data /var/www/.ssh && \
    chmod 700 /var/www/.ssh && \
    chmod 700 /var/www/.ssh/keys && \
    chmod -R 600 /var/www/.ssh/keys/* && \
    ln -s /var/www /home/www-data

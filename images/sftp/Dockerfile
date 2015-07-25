FROM atmoz/sftp@sha256:d64f8933f49e4fd73f0c1e81e7087672107087c1b9efd0a63734460ee2d19d3b

RUN mkdir -p /var/www/.ssh/keys

COPY keys/*.pub /var/www/.ssh/keys/

RUN chown -R www-data:www-data /var/www/.ssh && \
    chmod 700 /var/www/.ssh && \
    chmod 700 /var/www/.ssh/keys && \
    chmod -R 600 /var/www/.ssh/keys/* && \
    ln -s /var/www /home/www-data

FROM wordpress@sha256:be6523c9744276a8e458b6b4d284260aa88955cd5c4adb9019c0e62a6c75a16c

ADD . /docker-build

RUN chmod -R 777 /docker-build
RUN /docker-build/setup.sh && rm -rf /docker-build

ENTRYPOINT ["super-entrypoint.sh"]
CMD ["apache2-foreground"]

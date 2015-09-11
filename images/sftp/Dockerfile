FROM atmoz/sftp@sha256:ccdfdfba84cdd4222249d267e50b5e49a9556b9ad605310ffcb0f0f392f63953

ADD . /docker-build

RUN chmod -R 777 /docker-build
RUN /docker-build/setup.sh && rm -rf /docker-build

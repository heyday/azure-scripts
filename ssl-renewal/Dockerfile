FROM ubuntu:18.04

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y curl && \
    apt-get install -y unzip && \
    apt-get install -y certbot && \
    apt-get install -y pwgen
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

COPY auth.sh .
COPY run.sh .
RUN chmod +x run.sh

CMD ["bash", "run.sh"]

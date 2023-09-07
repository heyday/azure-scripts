FROM ubuntu:22.04

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y curl && \
    apt-get install -y unzip && \
    apt-get install -y certbot && \
    apt-get install -y pwgen
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

COPY auth.sh .
COPY run.sh .
COPY check-expiry.sh .

RUN chmod +x run.sh
RUN chmod +x auth.sh
RUN chmod +x check-expiry.sh

CMD ["bash", "run.sh"]

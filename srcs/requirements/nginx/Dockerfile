ARG IMAGE_VERSION=trixie

FROM debian:${IMAGE_VERSION}

RUN apt update -y && apt upgrade -y && apt install nginx -y

# CMD executed when the contianer is start
CMD ["nginx", "-g", "daemon off;"]

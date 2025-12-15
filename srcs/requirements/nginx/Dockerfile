ARG IMAGE_VERSION=trixie

FROM debian:${IMAGE_VERSION}

# RUN executed when the image is created
RUN apt update -y && apt upgrade -y && apt install nginx -y

EXPOSE 80

# CMD executed when the contianer is start
CMD ["nginx", "-g", "daemon off;"]

FROM alpine:3.18

RUN apk update && apk upgrade && apk add --no-cache nginx openssl

COPY requirements/nginx/conf/nginx.conf /etc/nginx/http.d/nginx.conf

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=DE/L=Heilbronn/OU=42Heilbronn/CN=ccompote.42.fr"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

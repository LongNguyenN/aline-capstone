FROM alpine:3
RUN apk add nodejs npm
WORKDIR /microservice
COPY . .
RUN npm rebuild node-sass
RUN npm i
CMD npm start
EXPOSE 3001

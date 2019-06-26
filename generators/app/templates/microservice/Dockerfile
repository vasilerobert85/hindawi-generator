FROM node:10-alpine

WORKDIR /app

COPY . .

RUN apk --no-cache add --virtual native-deps \
  python2 g++ gcc make \
  && yarn install --frozen-lockfile \
  && yarn cache clean \
  && apk del native-deps

ENV NODE_ENV "production"

EXPOSE 3000

CMD ["yarn", "start"]
FROM node:18 as compile
WORKDIR /app

COPY package.json yarn.lock ./
ENV HUSKY 0
RUN yarn install

COPY tsconfig.json index.html vite.config.ts ./
COPY public/ ./public
COPY src/ ./src
RUN yarn run build

FROM nginx:1.23-alpine as runtime

RUN rm -rf /usr/share/nginx/html
COPY --from=compile /app/build /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80


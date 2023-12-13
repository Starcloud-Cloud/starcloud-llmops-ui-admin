FROM node:18 AS builder
ARG env
ENV NODE_ENV ${env}

WORKDIR /usr/src/app/
USER root
COPY package.json ./

RUN npm config set registry https://registry.npmmirror.com
RUN npm i pnpm -g

RUN pnpm config set registry https://registry.npmmirror.com
RUN pnpm install

COPY ./ ./

# RUN npm run build:${NODE_ENV}
RUN npm run build:cn-test


FROM nginx

WORKDIR /usr/share/nginx/html/

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /usr/src/app/dist  /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
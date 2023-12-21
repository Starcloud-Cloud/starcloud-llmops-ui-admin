FROM node:18 AS builder
ARG env
ENV NODE_ENV ${env}

WORKDIR /usr/src/app/
USER root
COPY package.json ./

RUN yarn config set registry https://registry.npmmirror.com
RUN yarn 

COPY ./ ./

RUN npm run build:${NODE_ENV}
# RUN npm run build:cn-test


FROM nginx

WORKDIR /home/admin

#COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /usr/src/app/dist  /home/admin

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

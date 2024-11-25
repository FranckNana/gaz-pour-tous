FROM node:latest AS build

WORKDIR /usr/local/app

COPY ./ /usr/local/app/

RUN npm install -g @angular/cli

RUN npm install -f

RUN npm run build


FROM nginx:latest

COPY nginx.conf /etc/nginx/conf.d/nginx.conf

COPY --from=build /usr/local/app/dist/gradus/browser /usr/share/nginx/html

EXPOSE 80
FROM node
RUN mkdir -p ./app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app/
EXPOSE 8080
CMD ["node", "app.js"]
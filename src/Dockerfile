FROM node:19-alpine

ARG port=3000

WORKDIR /app
COPY package*.json ./

RUN npm install
COPY . .

EXPOSE ${port}
ENV PORT=${port}

ENTRYPOINT [ "node", "index.js" ]

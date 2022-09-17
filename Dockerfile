FROM debian:buster

RUN mkdir -p /app

RUN apt update && apt upgrade -y && apt install -y \
    curl
    
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sh

RUN apt install -y nodejs 

RUN npm install -g @nestjs/cli
RUN npm install -g prisma
RUN prisma db pull

RUN echo "npm i && npm run start" > /start.sh

WORKDIR /app

CMD ["sh", "/start.sh"]
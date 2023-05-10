# Base image
FROM node:20-alpine3.16 as BUILD_IMAGE

# Create app directory
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

# Install app dependencies
RUN npm install

# Bundle app source
COPY . .

# run prebuild script to remove dist folder
RUN npm run prebuild

# Creates a "dist" folder with the production build
RUN npm run build


RUN npm prune --production

FROM node:20-alpine3.16

WORKDIR /usr/src/app

COPY --from=BUILD_IMAGE /usr/src/app/dist ./dist
COPY --from=BUILD_IMAGE /usr/src/app/node_modules ./node_modules

EXPOSE 3000

# Start the server using the production build
CMD [ "node", "dist/main.js" ]
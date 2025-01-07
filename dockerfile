# 1. Choose a base image for Node (e.g., Node 20)
FROM node:20

# 2. Set the working directory
WORKDIR /app

# 3. Copy package.json and package-lock.json first for Docker caching
COPY package.json package-lock.json ./

# 4. Install dependencies using npm
RUN npm install

# 5. Copy the rest of your Strapi project files
COPY . .

# 6. Build the Strapi admin panel
RUN npm run build

# 7. Expose Strapi's default port
EXPOSE 1337

# 8. Start Strapi
CMD ["npm", "run", "start"]
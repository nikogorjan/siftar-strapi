# Stage 1: Build the Strapi Admin Panel
FROM node:20-alpine AS build

# Install dependencies required for building
RUN apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev git bash

# Set environment variables
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Set working directory
WORKDIR /opt/app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install --only=production

# Copy the rest of the application code
COPY . .

# Build the Strapi admin panel
RUN npm run build

# Stage 2: Create the production image
FROM node:20-alpine

# Install runtime dependencies
RUN apk add --no-cache vips-dev

# Set environment variables
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Set working directory
WORKDIR /opt/app

# Copy node_modules and built admin panel from the build stage
COPY --from=build /opt/app/node_modules ./node_modules
COPY --from=build /opt/app ./

# Ensure proper permissions
RUN chown -R node:node /opt/app

# Switch to non-root user
USER node

# Expose Strapi's default port
EXPOSE 1337

# Start Strapi in production mode
CMD ["npm", "run", "start"]

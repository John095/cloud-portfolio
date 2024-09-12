# # Use the official Node.js 18 Alpine image as the base image
# FROM node:22-alpine AS base

# # Set the working directory
# WORKDIR /app

# # Copy package.json and package-lock.json (or yarn.lock) to the working directory
# COPY package*.json ./

# # Copy specific node_modules packages
# RUN mkdir -p node_modules/@fortawesome
# COPY node_modules/@fortawesome node_modules/@fortawesome

# # Install dependencies
# RUN npm install

# # Copy the rest of the application code
# COPY . .

# # Build the Next.js application
# RUN npm run build

# # Production image
# FROM node:22-alpine AS production

# # Set the working directory
# WORKDIR /app

# # Copy package.json and install only production dependencies
# COPY package*.json ./
# RUN npm i


# # Copy the built application from the base stage
# COPY --from=base /app/.next ./.next
# COPY --from=base /app/public ./public
# COPY --from=base /app/node_modules ./node_modules

# # Set environment variables
# ENV NODE_ENV=production

# # Ensure the .next directory exists before applying permissions
# # RUN if [ -d "/app/.next" ]; then chown -R node:node /app/.next && chmod -R 755 /app/.next; fi


# # Expose the port the app runs on
# EXPOSE 3000

# # Run the Next.js application
# CMD ["npm", "start"]


# # Use the official Node.js image as the base
# FROM node:22-alpine

# # Set the working directory
# WORKDIR /app

# # Install dependencies
# COPY package*.json ./
# RUN mkdir -p node_modules/@fortawesome
# COPY node_modules/@fortawesome node_modules/@fortawesome
# RUN npm install

# # Copy the rest of the application code
# COPY . .

# # Expose the port Next.js will run on
# EXPOSE 3000

# # Start the development server
# CMD ["npm", "run", "dev"]


# Use the official Node.js image as the base
FROM node:22-alpine

# Set the working directory
WORKDIR /app

# Copy only package.json and package-lock.json
COPY package*.json ./

# Copy specific node_modules packages
RUN mkdir -p node_modules/@fortawesome
COPY node_modules/@fortawesome node_modules/@fortawesome


# Install all dependencies temporarily
RUN npm i

# Remove the remaining node_modules to reduce image size
RUN rm -rf node_modules/* && \
    npm i --omit=dev

# Copy the rest of the application code
COPY . .

# Expose the port for the application
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
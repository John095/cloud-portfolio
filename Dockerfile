# Use the official Node.js 18 Alpine image as the base image
FROM node:22-alpine AS base

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock) to the working directory
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Production image
FROM node:22-alpine AS production

# Set the working directory
WORKDIR /app

# Copy package.json and install only production dependencies
COPY package*.json ./
RUN npm ci --omit=dev


# Copy the built application from the base stage
COPY --from=base /app/.next ./.next
COPY --from=base /app/public ./public
COPY --from=base /app/node_modules ./node_modules

# Set environment variables
ENV NODE_ENV=production

# Ensure the .next directory exists before applying permissions
# RUN if [ -d "/app/.next" ]; then chown -R node:node /app/.next && chmod -R 755 /app/.next; fi


# Expose the port the app runs on
EXPOSE 3000

# Run the Next.js application
CMD ["npm", "start"]

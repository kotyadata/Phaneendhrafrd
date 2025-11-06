# Use official Node.js LTS image
FROM node:18-alpine

# Set working directory inside the container
WORKDIR /usr/src/app

# Copy package files first (for caching)
COPY node-app/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app source code
COPY node-app/ .

# Expose app port
EXPOSE 3000

# Start the Node.js app
CMD ["node", "index.js"]

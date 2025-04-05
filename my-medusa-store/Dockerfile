# Use Node.js 20 (matches package.json engines: ">=20")
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install all dependencies (including devDependencies for npm run dev)
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose port 9000 (default Medusa port)
EXPOSE 9000

# Command will be overridden in docker-compose.yml for npm run dev
CMD ["npm", "run", "dev"]
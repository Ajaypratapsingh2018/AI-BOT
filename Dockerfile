## Multi-stage Dockerfile to build and serve the Vite React app with Nginx

FROM node:20-alpine AS builder
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# Runtime stage: serve static files via Nginx
FROM nginx:1.27-alpine AS runtime

# Copy Nginx config for SPA routing
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy built assets
COPY --from=builder /app/dist /usr/share/nginx/html

# Non-root best practice
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]



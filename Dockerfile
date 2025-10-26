# Stage 1: Build the React frontend
FROM node:18-alpine AS builder
WORKDIR /app/client
COPY client/package.json client/package-lock.json ./
RUN npm install
COPY client/ ./
RUN npm run build

# Stage 2: Build the FastAPI backend
FROM python:3.10-slim
WORKDIR /app
COPY --from=builder /app/client/dist ./client/dist
COPY requirements.txt .
RUN apt-get update &&     apt-get install -y --no-install-recommends libgl1 &&     rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 4000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "4000"]

#!/bin/bash

# Dockerfile for Vulnerable Application
# Multi-stage build for optimal size

FROM python:3.11-slim AS base

LABEL maintainer="Cybersecurity Course"
LABEL description="Vulnerable Application - Network Reconnaissance Training"

WORKDIR /app

# Install any system dependencies if needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Copy vulnerable application
COPY vulnerable-app.py /app/vulnerable-app.py
COPY start-vulnerable-app.sh /app/start-vulnerable-app.sh

# Make scripts executable
RUN chmod +x /app/vulnerable-app.py /app/start-vulnerable-app.sh

# Set environment variable for Python
ENV PYTHONUNBUFFERED=1

# Expose all necessary ports
EXPOSE 8080 2222 2121 2323 2525

# Health check
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Run the vulnerable application
ENTRYPOINT ["python3"]
CMD ["vulnerable-app.py"]


#!/bin/bash

# Dockerfile for Vulnerable Application
# This creates a Docker image with the vulnerable PoC application

FROM python:3.11-slim

LABEL maintainer="Cybersecurity Course"
LABEL description="Vulnerable Application - Proof of Concept for Nmap Demonstrations"

WORKDIR /app

# Copy vulnerable application
COPY vulnerable-app.py /app/vulnerable-app.py

# Expose all necessary ports
EXPOSE 8080 2222 2121 2323 2525

# Set environment variable
ENV PYTHONUNBUFFERED=1

# Run the vulnerable application
CMD ["python3", "vulnerable-app.py"]

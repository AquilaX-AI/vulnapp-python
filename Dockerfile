FROM python:3.11-slim-bullseye

LABEL maintainer="AquilaX Ltd <admin[AT]aquilax.ai>"

# Install system dependencies (some with GPL licenses for testing)
RUN apt update -y && apt install -y \
    curl \
    git \
    gcc \
    libffi-dev \
    libssl-dev \
    # GPL licensed packages for container license testing
    bash \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=1

COPY ./ /app

WORKDIR /app/

RUN pip install --no-cache-dir -r requirements.txt

ENV PYTHONPATH=/app
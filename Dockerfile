FROM python:3.11-slim-bullseye

LABEL maintainer="AquilaX Ltd <admin[AT]aquilax.ai>"
LABEL description="Intentional Vulnerable Python Application - License Test Cases"

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
ENV PYTHONDONTWRITEBYTECODE=1

COPY ./ /app

WORKDIR /app/

RUN pip install --no-cache-dir -r requirements.txt

ENV PYTHONPATH=/app

# Expose Flask default port
EXPOSE 5000

CMD ["python", "app.py"]

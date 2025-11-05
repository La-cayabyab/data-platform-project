FROM kestra/kestra:latest

USER root

# Install Python and pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY data-ingestion/requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy your source code
COPY data-ingestion/src/ src/

USER kestra
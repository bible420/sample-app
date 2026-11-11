#!/bin/bash

set -e

# Create directories
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Copy application files
cp sample_app.py tempdir/
cp -r templates/. tempdir/templates/
cp -r static/. tempdir/static/

# Create Dockerfile
cat > tempdir/Dockerfile <<'EOF'
FROM python:3.11-slim
RUN pip install --no-cache-dir --progress-bar off flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD ["python", "/home/myapp/sample_app.py"]
EOF

# Remove old container
docker rm -f samplerunning 2>/dev/null || true

# Build image
docker build --pull=false -t sampleapp tempdir

# Start container
docker run -d \
  --name samplerunning \
  -p 5050:5050 \
  sampleapp

# Display status
docker ps -a

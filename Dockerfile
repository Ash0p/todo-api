# Start from a small, official Python image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Copy only requirements first (Docker caches this layer so rebuilds are faster)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Now copy the rest of the app code
COPY . .

# Tell Docker which port the app listens on
EXPOSE 5000

# Command to run when the container starts
CMD ["python", "app.py"]

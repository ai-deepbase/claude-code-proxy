FROM python:3.12-slim

WORKDIR /claude-code-proxy

# Avoid uv downloading CPython; force using system Python inside the image
ENV UV_PYTHON_DOWNLOADS=never
ENV UV_PYTHON_PREFERENCE=system
ENV UV_PYTHON=python3.12

# Copy package specifications
COPY pyproject.toml uv.lock ./

# Install uv and project dependencies
RUN pip install --upgrade uv && uv sync --locked

# Copy project code to current directory
COPY . .

# Start the proxy
EXPOSE 8082
CMD uv run uvicorn server:app --host 0.0.0.0 --port 8082 --reload

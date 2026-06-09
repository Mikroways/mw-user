FROM docker:27-dind
RUN apk add --no-cache python3 python3-dev curl bash git libffi-dev build-base openssl-dev rsync
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"
WORKDIR /project
COPY pyproject.toml uv.lock ./
RUN uv sync
ENV VIRTUAL_ENV=/project/.venv
ENV PATH="/project/.venv/bin:$PATH"

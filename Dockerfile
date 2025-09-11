ARG PYTHON_VERSION=3.12
ARG VARIANT=trixie
ARG DOCKERIZE_VERSION=0.16.0

FROM powerman/dockerize:${DOCKERIZE_VERSION} as dockerize
FROM ghcr.io/withlogicco/python:${PYTHON_VERSION}-${VARIANT} AS no-mssql
COPY --from=dockerize --link /usr/local/bin/dockerize /usr/local/bin/dockerize

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    uv sync --no-install-project

COPY . .

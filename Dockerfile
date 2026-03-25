FROM python:3.12.1-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY ./requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY ./ ./

ARG APP_VERSION
ENV APP_VERSION=$APP_VERSION
ENV STORAGE_URL="osfs:///uploads"

RUN useradd -r -u 3003 -s /usr/sbin/nologin -d /nonexistent -M runner && \
    mkdir -p /uploads && \
    chown -R 3003:3003 /app /uploads

EXPOSE 8000

USER 3003

CMD ["uvicorn", "--host=0.0.0.0", "--port=8000", "app_distribution_server.app:app"]
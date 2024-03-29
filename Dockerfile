FROM python:3.9-slim

ARG GEMFURY_DOWNLOAD_KEY
ENV FLASK_APP dhos_users_api/autoapp.py

WORKDIR /app

COPY poetry.lock pyproject.toml ./

RUN apt-get update \
    && apt-get install -y wait-for-it curl nano \
    && useradd -m app \
    && chown -R app:app /app \
    && pip install --upgrade pip poetry \
    && poetry config http-basic.sensynehealth ${GEMFURY_DOWNLOAD_KEY:?Missing build argument} '' \
    && poetry config virtualenvs.create false \
    && poetry install -v --no-dev

COPY --chown=app . ./

USER app

EXPOSE 5000

CMD ["python", "-m", "dhos_users_api"]

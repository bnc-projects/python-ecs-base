FROM python:3.7.7-slim-buster

COPY requirements.txt /requirements.txt
RUN pip install -r requirements.txt && rm -rf /root/.cache/

RUN groupadd -g 999 appuser && useradd -r -u 999 -g appuser appuser
USER appuser

EXPOSE 80

ENTRYPOINT exec python -u /app/main.py

COPY src /app


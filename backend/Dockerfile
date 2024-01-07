FROM python:3.11-slim-bullseye

WORKDIR /backend
COPY . ./
RUN apt update && apt install -y gcc g++ build-essential binutils python-dev

WORKDIR /backend/app
RUN pip install -r requirements.txt

WORKDIR /backend
EXPOSE 3000

ENTRYPOINT ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "3000"]
FROM python:latest

WORKDIR /app

COPY nginx.conf /etc/nginx/nginx.conf

COPY . /app/

RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]
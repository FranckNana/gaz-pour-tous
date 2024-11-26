FROM python:3.11.1

COPY requirements.txt requirements.txt

RUN python -m pip install --upgrade pip && python -m pip install -r requirements.txt

COPY app.py .
COPY bottle.py .
COPY pg_utils.py .
COPY user.py .
COPY utils.py .

EXPOSE 5000
CMD ["waitress-serve", "--listen=*:5000", "app:app"]

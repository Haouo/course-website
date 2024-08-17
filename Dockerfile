FROM squidfunk/mkdocs-material:latest

WORKDIR /docs

COPY requirements.txt /docs/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /docs

CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]

LOAD_HOST = http://localhost:8000/
LOAD_HOST_MD5 = $(shell echo $(LOAD_HOST) | md5sum | cut -d' ' -f1)
LOAD_CONCURRENCY = 10
LOAD_DURATION = 5s
PORT = 8000

gunicorn:
	uv run gunicorn -w 4 --bind 127.0.0.1:$(PORT) pycon:app

uvicorn:
	uv run uvicorn pycon:app.asgi --interface asgi3 --port "$(PORT)"

migrate:
	uv run nanodjango manage pycon.py migrate

collectstatic:
	uv run nanodjango manage pycon.py collectstatic -- --no-input

dev:
	uv run nanodjango run pycon.py

loadtest:
	echo "GET $(LOAD_HOST)api/" | vegeta attack -duration=$(LOAD_DURATION) -max-workers=$(LOAD_CONCURRENCY) | tee $(LOAD_HOST_MD5).bin | vegeta report
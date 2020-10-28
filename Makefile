AIRFLOW_VERSION=1.10.12

build: container

container:
	docker build \
		--build-arg VERSION=${AIRFLOW_VERSION} \
		-t all-in-one \
		.
	touch container

clean:
	rm container

airflow-run: build
	docker-compose up

dev:
	docker run --rm \
		--name=jupyter \
		-p 8888:8888 \
		-e JUPYTER_ENABLE_LAB=yes \
		--env-file=$$(pwd)/resources/config/airflow.env \
		-v $$(pwd)/src/notebooks:/home/jovyan/work:Z \
		all-in-one

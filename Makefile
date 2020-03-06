SHELL = /bin/bash

build:
	docker build \
		--build-arg GDAL_VERSION=3.0 \
		--build-arg REQ_VERSION=gdal3.0 \
		--tag vexcel/amazonlinux:gdal3.0-py3.7 .

layer: build
	docker run \
		--name lambda \
		-w /var/task \
		--volume $(shell pwd)/:/local \
		-itd vexcel/amazonlinux:gdal3.0-py3.7 \
		bash
	docker exec -it lambda bash '/local/scripts/create-lambda-layer.sh'	
	docker cp lambda:/tmp/package.zip gdal3.0-py3.7.zip
	docker stop lambda
	docker rm lambda

build2:
	docker build \
		--build-arg GDAL_VERSION=2.4 \
		--build-arg REQ_VERSION=gdal2.4 \
		--tag vexcel/amazonlinux:gdal2.4-py3.7 .

layer2: build2
	docker run \
		--name lambda \
		-w /var/task \
		--volume $(shell pwd)/:/local \
		-itd vexcel/amazonlinux:gdal2.4-py3.7 \
		bash
	docker exec -it lambda bash '/local/scripts/create-lambda-layer.sh'	
	docker cp lambda:/tmp/package.zip gdal2.4-py3.7.zip
	docker stop lambda
	docker rm lambda


clean:
	docker stop lambda
	docker rm lambda

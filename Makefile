SHELL = /bin/bash

build:
	docker build \
		--build-arg GDAL_VERSION=3.0 \
		--tag vexcel/amazonlinux:gdal3.0-py3.7-osgeo .

layer: build
	docker run \
		--name lambda \
		-w /var/task \
		--volume $(shell pwd)/:/local \
		-itd vexcel/amazonlinux:gdal3.0-py3.7-osgeo \
		bash
	docker exec -it lambda bash '/local/scripts/create-lambda-layer.sh'	
	docker cp lambda:/tmp/package.zip gdal3.0-py3.7-osgeo.zip
	docker stop lambda
	docker rm lambda

build2:
	docker build \
		--build-arg GDAL_VERSION=2.4 \
		--tag vexcel/amazonlinux:gdal2.4-py3.7-osgeo .

layer2: build2
	docker run \
		--name lambda \
		-w /var/task \
		--volume $(shell pwd)/:/local \
		-itd vexcel/amazonlinux:gdal2.4-py3.7-osgeo \
		bash
	docker exec -it lambda bash '/local/scripts/create-lambda-layer.sh'	
	docker cp lambda:/tmp/package.zip gdal2.4-py3.7-osgeo.zip
	docker stop lambda
	docker rm lambda


clean:
	docker stop lambda
	docker rm lambda

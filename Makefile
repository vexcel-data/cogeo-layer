SHELL = /bin/bash

buildgdal3:
	docker build \
		--build-arg GDAL_VERSION=3.0 \
		--build-arg REQ_VERSION=only-gdal30 \
		--tag vexcel/amazonlinux:gdal3.0-py3.7 .

layergdal3: buildgdal3
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

buildgdal2:
	docker build \
		--build-arg GDAL_VERSION=2.4 \
		--build-arg REQ_VERSION=only-gdal24 \
		--tag vexcel/amazonlinux:gdal2.4-py3.7 .

layergdal2: buildgdal2
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

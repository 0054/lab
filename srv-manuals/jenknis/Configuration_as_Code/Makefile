
test-env: docker-clean docker-build docker-run

docker-logs:
	docker logs jenkins_casc -f 

docker-build:
	docker build -t jenkins_casc:latest .

docker-run:
	docker run --rm -d --name jenkins_casc -p 8080:8080 -p 50000:50000 -v jenkins_casc_home:/var/jenkins_home jenkins_casc:latest

docker-stop:
	docker stop jenkins_casc || true
docker-rm-volume:
	docker volume rm jenkins_casc_home || true
docker-clean: docker-stop docker-rm-volume

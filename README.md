This is the docker build file for the QA TW Jenknis server

Build Docker Image:

docker build -t jenkins-prive . 

(this tag `jenkins-prive` should match the image in docker-compose.yml)


Run Docker Container:

`docker-compose up -d`

Destroy Docker Container:
`docker-compose down`

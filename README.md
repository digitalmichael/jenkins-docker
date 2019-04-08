# jenkins-docker

playground for Jenkins. This repo allows you to build a custom jenkins docker image with plugins and a job pre installed. This does assume you can mount the docker.sock locally and was developed and run on OSX.

## Notes

- secrets section currently not working
```
-run this to populate secrets:

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -
```

get plugins: (on osx run `brew install jq`) only if you want a new export. The included plugins.txt is fine.

`curl -s -k "http://username:password@localhost:8080/pluginManager/api/json?depth=1" | jq -r '.plugins[] | .shortName +":"+.version' | tee plugins.txt`

## Build Jenkins Container
- --no-cache builds without cache. Slower but can resolve issues when making changes to the Dockerfile. remove that flag if you want a faster build.

`docker build -t "jenkins-docker" . --no-cache`

## run the jenkins-docker image:

`docker run -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock --name jenkins jenkins-docker`

## laradock-nginx

includes a job that clones the laradock repo and builds the nginx container. 

## Notes on sibling containers

Even though Jenkins is running in a container we are mapping the docker.sock to the Hosts docker.sock. What this means is that when the laradock-nginx job is run the resulting image is stored on the Host and not the Jenkins container. This is referred to as running a sibling container versus a child.

run `docker images` on the Host to verify that the laradock-nginx image is there to prove this.

## Cleanup

be sure to tidy up if you build things a lot

`docker ps -a` to see any stopped containers. Run `docker rm <image_ID>` to delete any images you do not want anymore.

`docker images` to see a list of all images. You likely want to clean this up by running `docker images <image_ID>` on each image you want deleted.

# TODO

work to have cleanup more automated. Add a sibling container that runs a private registry and publish to that.



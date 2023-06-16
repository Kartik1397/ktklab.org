% How to view content of docker image layers?

## Short Answer

Use [docker-image-layer-explorer](https://github.com/Kartik1397/docker-image-layer-explorer){target="_blank"}

```
docker-image-layer-explorer <image-id> --layer <layer-id> --extract ./
```

## Full Story

While exploring a new repository of some project I came across a Dockerfile similar to following.

```
FROM node
WORKDIR /app

COPY . .
RUN rm config/some-secrete.json
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000
CMD /bin/bash /app/start_app.sh
```

The issue with this Dockerfile is that the author used the `RUN` command to remove a file containing a secret (`config/some-secrete.json`). However, a malicious actor could still access the secret file from the image layer created by the `COPY . .` command. To prove my theory, I needed to find evidence by examining the layers of the Docker image.

After some research, I came across [dive](https://github.com/wagoodman/dive){target="_blank"}, a tool designed to explore each layer within a Docker image. Using dive, I ran an analysis on an image generated from the aforementioned Dockerfile, and indeed, I found that the secret file was present in one of the layers. Unfortunately, dive does not provide the functionality to download or extract a specific layer.

![Screenshot of dive in action](/images/dive.webp)

So, I started exploring how docker image works, I delved into two valuable resources: the [Docker Image Specification v1.2.0](https://github.com/moby/moby/blob/master/image/spec/v1.2.md){target="_blank"} and [a comment explaining the manual extraction process](https://github.com/wagoodman/dive/issues/336#issuecomment-1530196172){target="_blank"}. These resources helped me to understand the structure of Docker images.

By utilizing the `docker save` command, we can export the image as a tar file and gain access to additional information about each layer from the JSON files contained within the tar file. To extract a specific layer, we simply need to extract the `<layer-id>/layer.tar` file.

However, manually executing 5 to 6 commands each time can be time-consuming, and I also wanted to identify which Docker command corresponds to each layer. To simplify this process, I developed the [docker-image-layer-explorer](https://github.com/Kartik1397/docker-image-layer-explorer){target="_blank"} tool. It streamlines the task of viewing Docker image layers and provides insights into the relationship between Docker commands and the layers they create.


# Docker files for Alsvinn

To build:

    cd nvidia/git
    docker --build . -t kjetilly/alsvinn:git

To push:

   docker login
   docker push kjetilly/alsvinn:git


To run:
   docker run --runtime nvidia --rm kjetilly/alsvinn.git
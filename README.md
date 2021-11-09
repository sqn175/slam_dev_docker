# SLAM Development Docker
Since there isn't an official package manager for C/C++, its always time-consuming and annoying for SLAM developers to setup a develop environment. This repo aim to provide reusable installer scripts for commonly used SLAM third-party libraries and merge them all together into various base Docker containers. Based on this repo, you may customize your environment to quickly run different SLAM algorithms for comparison, maintain a consitent SLAM development environment, or distribute your own SLAM algorithm with the container for rapid spread. Several SLAM develop environments are already shipped in the git branches.

## Requirement

Docker installed. [Install Docker Engine](https://docs.docker.com/engine/install/)

## Basic Usage

1. Build the Docker image:

   ```
   ./build.sh
   ```

2. Run the Docker image, which will mount the host source directory into container according to  `HOST_SOURCE_DIR` in `run.sh`:

   ```
   ./run.sh
   ```

## Notes

1. You can customize the docker via modifying `installers/install_3rdparties_dev.sh` to install required third-party libraries.

2. Some source mirrors such as apt and python mirrors are modified to China mirrors to improve download speed for China mainland users.

3. You can manually pre-download third-party lib source code tarball files into archive dir for offline Docker building.

4. You can develop your SLAM algorithm using VS Code inside the containers, just modify the the attributes of `./devcontainer/devcontainer.json`  in VSCode:

   ```json
   "build": {
        "dockerfile": "pathto/Dockerfile.ubuntu18-opengl",
   },
   ```

   See more details in [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers).

5. **Welcome to contribute new installers needed for SLAM development and create new branches to host the State-of-the-Art SLAM algorithm development environments.**

## Acknowledgement
Some part of source code are adapted from [Baidu Apollo](https://github.com/ApolloAuto/apollo), which is licensed under the [Apache-2.0 license](https://github.com/ApolloAuto/apollo/blob/master/LICENSE).




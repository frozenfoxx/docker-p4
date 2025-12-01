# docker-p4

[![Build](https://github.com/frozenfoxx/docker-p4/actions/workflows/build.yml/badge.svg)](https://github.com/frozenfoxx/docker-p4/actions/workflows/build.yml)

A [Docker](https://docker.io) container for running a [Perforce P4](https://help.perforce.com/helix-core/quickstart/current/Content/quickstart/Home-quickstart.html) server.

Docker Hub: https://hub.docker.com/r/frozenfoxx/p4

# How to Build

To build the default image input the following:

```Shell
git clone https://github.com/frozenfoxx/docker-p4.git
cd docker-p4
docker build -t frozenfoxx/p4:latest .
```
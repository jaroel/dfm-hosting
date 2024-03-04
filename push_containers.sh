docker save dfmsite:latest | bzip2 | pv | ssh root@debian@orb docker load
docker save dfmproxy:latest | bzip2 | pv | ssh root@debian@orb docker load

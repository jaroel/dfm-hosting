docker save dfmsite:latest | bzip2 | pv | ssh root@debian@orb docker load
docker save dfmuzg:latest | bzip2 | pv | ssh root@debian@orb docker load


docker save dfmuzg:latest | bzip2 | pv | ssh root@dfmhost.toffe.site docker load

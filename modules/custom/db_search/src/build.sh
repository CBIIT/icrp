docker build -t icrp-search -f Dockerfile --progress plain .
docker run --rm -v $PWD/../assets:/tmp/output icrp-search
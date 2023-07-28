docker build -t icrp-search -f Dockerfile --progress plain .
docker run --rm -v %CD%\..\assets:/tmp/output icrp-search
from node:12

ENV ROOTDIR=/icrp

ENV WORKDIR=${ROOTDIR}/search/app

RUN mkdir -p ${WORKDIR} ${ROOTDIR}/assets /tmp/output

COPY angular ${WORKDIR}

WORKDIR ${WORKDIR}

RUN npm install 

RUN npm run build

CMD cp -r ${ROOTDIR}/assets/* /tmp/output
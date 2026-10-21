FROM node:12.22.12-bullseye-slim@sha256:730e5fe497e70bac60bb2bb6ec55007ddedbf6c49ce577820614c4873399ee7e

ENV ROOTDIR=/icrp

ENV WORKDIR=${ROOTDIR}/modules/custom/db_search/src/angular

RUN mkdir -p ${WORKDIR} /tmp/output

COPY tools/check-frontend-toolchain.cjs ${ROOTDIR}/tools/check-frontend-toolchain.cjs
COPY modules/custom/db_search/src/angular ${WORKDIR}

WORKDIR ${WORKDIR}

RUN npm ci --no-audit --no-fund

RUN npm run build

CMD cp -r ${ROOTDIR}/modules/custom/db_search/assets/. /tmp/output/

FROM mhart/alpine-node

MAINTAINER Henrik Jonsson <me@hkjn.me>

RUN npm install -g node-gyp@3.2.1 && \
    mkdir /usr/local/src && \
    cd /usr/local/src/ && \
    apk add --no-cache git && \
    git clone https://github.com/brave/browser-laptop && \
    cd browser-laptop/ && \
    npm test && \
    npm install && \
    cd node_modules/abp-filter-parser-cpp && \
    make

CMD ["npm", "start"]
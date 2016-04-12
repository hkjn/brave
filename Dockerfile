FROM alpine

MAINTAINER Henrik Jonsson <me@hkjn.me>

RUN apk add --no-cache python g++ && \
    adduser brave -D && \
    apk add --no-cache make git nodejs python && \
    chown brave:brave /usr/lib/node_modules
USER brave
RUN npm install -g bloom-filter-cpp
USER root

RUN npm install -g node-gyp@3.2.1 && \
    apk add --no-cache xvfb libgnome-keyring-dev
USER brave
WORKDIR /home/brave/
RUN mkdir -p src/github.com/brave && \
    cd src/github.com/brave && \
    git clone https://github.com/brave/browser-laptop
# TODO(hkjn): Find why binding.gyp is missing:
# gyp: binding.gyp not found (cwd: /home/brave/src/github.com/brave/browser-laptop/node_modules/lru_cache) while trying to load binding.gyp
# TODO(hkjn): Find why "npm install" looks for node-gyp in the wrong place:
# /bin/sh: ./node_modules/.bin/node-gyp: not found
WORKDIR /home/brave/src/github.com/brave/browser-laptop
RUN npm install
WORKDIR /home/brave/src/github.com/brave/browser-laptop/node_modules/abp-filter-parser-cpp
RUN make

# TODO(hkjn): Enable tests (npm test), if test dependencies can be
# made to work. After adding test packages with "npm install -g mocha
# babel-register", the "npm test" command fails with:
# > NODE_ENV=test mocha --compilers js:babel-register --recursive $(find test -name '*Test.js')
# /usr/lib/node_modules/babel-register/node_modules/babel-core/lib/transformation/file/options/option-manager.js:179
#          throw new ReferenceError(messages.get("pluginUnknown", plugin, loc, i, dirname));					          ^
# ReferenceError: Unknown plugin "transform-react-inline-elements" specified in "/usr/local/src/browser-laptop/.babelrc" at 0, attempted to resolve relative to "/usr/local/src/browser-laptop"

CMD ["npm", "start"]
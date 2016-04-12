FROM mhart/alpine-node

MAINTAINER Henrik Jonsson <me@hkjn.me>

# TODO(hkjn): Enable tests (npm test), if test dependencies can be
# made to work. After adding test packages with "npm install -g mocha
# babel-register", the "npm test" command fails with:
# > NODE_ENV=test mocha --compilers js:babel-register --recursive $(find test -name '*Test.js')
# /usr/lib/node_modules/babel-register/node_modules/babel-core/lib/transformation/file/options/option-manager.js:179
#          throw new ReferenceError(messages.get("pluginUnknown", plugin, loc, i, dirname));					          ^
# ReferenceError: Unknown plugin "transform-react-inline-elements" specified in "/usr/local/src/browser-laptop/.babelrc" at 0, attempted to resolve relative to "/usr/local/src/browser-laptop"

# TODO(hkjn): Figure out why bloom-filter-cpp has to be installed separately ahead of build.
RUN apk add --no-cache python make g++ && \
    npm install -g bloom-filter-cpp abp-filter-parser-cpp

WORKDIR /usr/local/src/github.com/brave
RUN npm install -g node-gyp@3.2.1 && \
    apk add --no-cache git && \
    git clone https://github.com/brave/browser-laptop && \
    cd browser-laptop && \
    npm install && \
    cd node_modules/abp-filter-parser-cpp && \
    make

CMD ["npm", "start"]
FROM node:10

EXPOSE 4200

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV NPM_CONFIG_LOGLEVEL info

# This should be on the dependencis of package.json
RUN npm install @angular-devkit/build-angular

# Adding Node App source code
ADD ./app/ /home/node/app

WORKDIR /home/node/app

RUN npm install

# node won't listen on all interfaces by default. You must
# change your package.json file so that ng serve will run with
# the --host 0.0.0.0 to make node listen on all interfaces:
#
# "proxy": "ng serve --host 0.0.0.0 --proxy-config proxy.config.json",
#

CMD cd /home/node/app && npm run proxy
FROM amirsamary/irisdemo:angular6
LABEL maintainer="Phillip Booth <phillip.booth@intersystems.com>"

# Adding Node App source code
ADD ./app/ /home/node/app

# You should only need this if your package.json is different from
# the one that the base image brings.
# WORKDIR /home/node/app
RUN npm install
rm config.tgz; tar -C ~/git/panther/panther-linux-install-bundler/build/panther2-bundle/opt/pcr/install -czf `pwd`/config.tgz panther2-jagless-linux-config

docker build -t jacto .

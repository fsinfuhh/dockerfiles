#!/bin/bash
BRANCH=beta
VERSION=`curl https://raw.githubusercontent.com/discourse/discourse/${BRANCH}/lib/version.rb 2>/dev/null | python -c "import re,sys;i = sys.stdin.read();v = re.search(r'MAJOR\s*=\s*(\d+).*?MINOR\s*=\s*(\d+).*?TINY\s*=\s*(\d+)', i, re.DOTALL); p = re.search(r'PRE\s*=\s*\'(\w+)\'', i, re.DOTALL); pr = '.' + p.group(1) if p else ''; print('{}.{}.{}'.format(*[v.group(n) for n in range(1, 4)]) + pr)"`
NAME=discourse

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base

acbuild run -- /usr/bin/env BRANCH=$BRANCH VERSION=$VERSION /bin/sh -es <<"EOF"
    useradd -u 3010 -g nogroup -d /opt/discourse discourse

    apt update
    apt -y install build-essential git curl bzip2 libxslt1-dev libcurl4-openssl-dev libksba8 libksba-dev libqtwebkit-dev libreadline-dev libsqlite3-dev sqlite3 postgresql-contrib imagemagick optipng gifsicle jpegoptim libjpeg-progs openssl zlib1g-dev libssl-dev libpq-dev

    cd /usr/local/share
    curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 > phantomjs-1.9.8-linux-x86_64.tar.bz2
    tar xvf phantomjs-1.9.8-linux-x86_64.tar.bz2
    rm phantomjs-1.9.8-linux-x86_64.tar.bz2
    ln -s /usr/local/share/phantomjs-1.9.8-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

    mkdir /opt/discourse
    chown discourse:nogroup /opt/discourse

    su discourse -s /bin/bash <<"EOG"
      export HOME=/opt/discourse
      touch $HOME/.bashrc
      . ~/.bashrc
      cd

      if [[ ! -d "$HOME/.rbenv" ]]; then
        # Installing rbenv ..."
          git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

          printf 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> ~/.bashrc
          printf 'eval "$(rbenv init - --no-rehash)"\n' >> ~/.bashrc

          . ~/.bashrc
          eval "$(rbenv init -)"
      fi


      if [[ ! -d "$HOME/.rbenv/plugins/rbenv-gem-rehash" ]]; then
        # Installing rbenv-gem-rehash so the shell automatically picks up binaries after installing gems with binaries...
        git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
      fi

      if [[ ! -d "$HOME/.rbenv/plugins/ruby-build" ]]; then
        # Installing ruby-build, to install Rubies ...
        git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
      fi

      ruby_version="2.3.0"

      # Installing Ruby $ruby_version ..."
        rbenv install "$ruby_version"

      # Setting $ruby_version as global default Ruby ..."
        rbenv global $ruby_version
        rbenv rehash

      # Updating to latest Rubygems version ..."
        gem update --system

      # Installing Rails ..."
        gem install rails -V

      # Installing Bundler ..."
        gem install bundler --no-document --pre
        
      # Installing Mailcatcher ..."
        gem install mailcatcher

      git clone --branch ${BRANCH} https://github.com/discourse/discourse.git
      cd discourse
      bundle install --deployment --without test
      gem install unicorn
EOG

    # link static
    mv /opt/discourse/discourse/public /opt/discourse/discourse/public_original
    ln -sf /opt/static /opt/discourse/discourse/public

    # link configuration
    ln -sf /opt/config/discourse.conf /opt/discourse/discourse/config/
    ln -sf /opt/config/local_unicorn.conf.rb /opt/discourse/discourse/config/
    ln -sf /opt/config/multisite.yml /opt/discourse/discourse/config/

    mkdir -p /opt/discourse/discourse/tmp/pids

    chown -R discourse:nogroup /opt/discourse
 
    # clean up
    rm -rf /opt/discourse/.rbenv/.git
    rm -rf /opt/discourse/discourse/.git
    rm -rf /opt/discourse/discourse/vendor/bundle/ruby/2.3.0/cache/*
    apt -y purge bzip2 postgresql
    apt-get -y autoremove
    apt-get clean


    # store startup script
    cat > /usr/local/bin/run <<EOG
#!/bin/bash
export USER=discourse HOME=/opt/discourse
. /opt/discourse/.bashrc
cd /opt/discourse/discourse

RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake multisite:migrate

cp -r /opt/discourse/discourse/public_original/* /opt/discourse/discourse/public/
# precompile assets in background
RAILS_ENV=production bundle exec rake assets:precompile &

RAILS_ENV=production RUBY_GC_MALLOC_LIMIT=50000000 UNICORN_SIDEKIQS=2 UNICORN_WORKERS=2 exec /opt/discourse/.rbenv/shims/bundle exec unicorn -c config/local_unicorn.conf.rb
EOG
    chmod +x /usr/local/bin/run

EOF

acbuild port add web tcp 10000
acbuild mount add config /opt/config
acbuild mount add static /opt/static
acbuild mount add log /opt/log
acbuild set-user -- discourse
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME

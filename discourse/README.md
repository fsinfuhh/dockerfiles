Prepare database
================

sudo -u postgres psql -d discourse -c "CREATE EXTENSION hstore;"
sudo -u postgres psql -d discourse -c "CREATE EXTENSION pg_trgm;"


Create admin
============

As discourse user in /opt/discourse/discourse:
```
RAILS_ENV=production bundle exec rake admin:create
```



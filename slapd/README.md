Populating data
===============

Launch the container with --exec /bin/bash and run

    cp -r /etc/ldap.dist/* /etc/ldap/
    dpkg-reconfigure slapd


If you have a terminal emulator not supported by default in debian stable, you should set it to something supported (i.e. xterm).

**Warning:** If dpkg-reconfigure hangs, this is probably due to reverse dns issues. Set a proper hostname in /etc/hosts then.



Indexing problems
=================

By default, there are a lot of indexing errors. Those can be fixed by manually editing /etc/ldap/slapd.d/cn=config/olcDatabase={1}hdb.ldif (TODO: add example configuration)

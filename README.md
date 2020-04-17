# mafiasi dockerfiles

In diesem Git werden die Skripte zum Bauen der mafiasi-Container gesammelt.

`base-buster` und `base-jessie` sind Basis-Images. Diese besteht aus einem minimalen Debian mit vim.

Alle Images können mit `podman` oder `docker` gebaut werden, z. B. so:

```
cd <name>
docker build --no-cache --squash -t registry.mafiasi.de/<name> .
```

## Container

Jeder Container ist in einem dedizierten Ordner gespeichert.
Dieser enthält neben der Dockerfile weitere Dateien, die in das Dateisystem kopiert werden.

Da alle Container-Images öffentlich sind, darf kein Passwort und keine privaten Schlüssel enthalten sein!
Diese sollten über den `/opt/config`-Mountpoint eingebunden werden und dann im Container per Symlink verknüpft werden.

# mafiasi-rkt

In diesem Git werden die Skripte zum Bauen der mafiasi-Container gesammelt.

`build-base.sh` ist das Skript, welches das Basis-Image baut. Dieses besteht aus
einem minimalen Debian Jessie mit automatischen Sicherheitsupdates.

Alle Image werden mit `acbuild` gebaut und liegen im aci-Format vor.

Zur Zeit muss `acbuild` mit dem Patch
`0001-Pipe-stdin-to-the-stdin-of-the-command-in-the-ACI.patch` gebaut werden.

## Container

Jeder Container ist in einem dedizierten Ordner gespeichert:

```
    gogs
    ├── config
    │   └── app.ini
    ├── gogs.sh
    ├── README.md
    └── TODO
```

Dabei ist `gogs.sh` das Hauptskript, welches mit `acbuild` das Container-Image
erstellt. Unter `config` befindet sich eine Beispielkonfiguration für den
Container. `config` soll bei der Ausführung unter `/opt/config` gemountet
werden. (Der Mountpoint heißt einfach `config`.)

Da alle Container-Images öffentlich sind, darf kein Passwort und keine privaten
Schlüssel enthalten sein! Diese sollten über den `config`-Mountpoint eingebunden
werden und dann im Container per Symlink verknüpft werden.

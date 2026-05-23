# Jamulus 🎶
Docker configuration for [Jamulus](https://github.com/jamulussoftware/jamulus) music server.

The Jamulus software enables musicians to perform real-time jam sessions over the internet. There is one server running the Jamulus server software which collects the audio data from each Jamulus client, mixes the audio data and sends the mix back to each client.

> **Note:** `--server` and `--nogui` are baked into the image entrypoint — you do not need to pass them manually.

# Usage

## docker

```bash
docker run \
  -e TZ=America/Los_Angeles \
  --name jamulus \
  -d --rm \
  -p 22124:22124/udp \
  -v $(pwd)/jam:/jam \
  rm968211/jamulus \
  -p 22124 -l /jam/jamulus.log -w "Welcome to Jamulus docker server."
```

## docker-compose

```yaml
---
version: "3.7"
services:
  jamulus:
    container_name: jamulus
    image: rm968211/jamulus
    restart: always
    ports:
      - "22124:22124/udp"
    environment:
      TZ: "America/Los_Angeles"
    command:
      - "--welcomemessage"
      - "Welcome to the Jamulus rehearsal room"
      - "--numchannels"
      - "16"
```

You can monitor output with `docker logs -f jamulus`

| ⚠️ To improve performance, please consider using docker's [realtime scheduler](https://docs.docker.com/config/containers/resource_constraints/#configure-the-realtime-scheduler) |
| --- |

## Building with a custom Jamulus version

The Jamulus version is a build argument and can be overridden at build time:

```bash
docker build --build-arg releaseversion=r3_12_1 -t rm968211/jamulus .
```

# Parameters

|Parameter   |Description   |
|---|---|
|-a, --servername |server name, required for HTML status |
|-d, --discononquit |disconnect all clients on quit |
|-e, --centralserver |address of the central server (or 'localhost' to be a central server) |
|-f, --listfilter |server list whitelist filter in the format:<br>`[IP address 1];[IP address 2];[IP address 3]; ...` |
|-F, --fastupdate |use 64 samples frame size mode |
|-g, --pingservers |ping servers in list to keep NAT port open (central server only) |
|-l, --log |enable logging, set file name |
|-L, --licence |a licence must be accepted on a new connection |
|-m, --htmlstatus |enable HTML status file, set file name |
|-o, --serverinfo |infos of the server(s) in the format:<br>`[name];[city];[country as QLocale ID]; ...`<br>`[server1 address];[server1 name]; ...`<br>`[server1 city]; ...`<br>`[server1 country as QLocale ID]; ...`<br>`[server2 address]; ... ` |
|-R, --recording |sets directory to contain recorded jams |
|--norecord |disables recording (when enabled by default by -R) |
|-p, --port |local port number |
|-T, --multithreading |use multithreading to make better use of multi-core CPUs and support more clients |
|-u, --numchannels |maximum number of channels |
|-w, --welcomemessage |welcome message on connect |
|-z, --startminimized |start minimized |

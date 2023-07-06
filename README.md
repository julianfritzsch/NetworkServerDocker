# NetworkServer.jl Docker

Docker container for <a href=https://github.com/julianfritzsch/NetworkServer.jl target=_blank>NetworkServer.jl</a>.
Find the container on <a href=https://hub.docker.com/r/julianfritzsch/networkserver target=_blank>Docker Hub</a>.

# Usage
By default the container uses the Gurobi license for the HEVS.
If you are in the HEVS network or want to use Ipopt simply run
```bash
docker run -dp 8080:8080 julianfritzsch/networkserver
```
To use a different Gurobi license, you need to pass the license to the container.
To do so type
```bash
docker run --volume=<path/to/license>:/opt/gurobi/gurobi.lic:ro -dp 8080:8080 julianfritzsch/networkserver
```

# Build
If you wanna build the container on your own, clone the repository and go to the folder.
Then type
```bash
docker build . -t networkserver
```
Afterwards you can use the above comments to run the server.
Simply replace `julianfritzsch/networkserver` with `networkserver`.

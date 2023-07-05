# NetworkServer.jl Docker

Docker container for [NetworkServer.jl](https://github.com/julianfritzsch/NetworkServer.jl).

Usage:
Clone the repository and enter the folder. Then run
```bash
docker build . -t networkserver
```
To use the server without Gurobi simply type
```bash
docker run -p 8080:8080 networkserver
```
To use Gurobi, you need to pass the license to the container.
To do so type
```bash
docker run --volume=<path/to/license>:/opt/gurobi/gurobi.lic:ro -p 8080:8080 networkserver
```

FROM debian:bookworm as build
ARG GRB_VERSION=10.0.0
ARG GRB_SHORT_VERSION=10.0

WORKDIR /opt

RUN arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
        'amd64') \
            PLAT='linux64';\
            ;;\
        'arm64') \
            PLAT='armlinux64';\
            ;;\
        *) \
            exit 1;\
            ;;\
    esac; \
    apt-get update \
    && apt-get install --no-install-recommends -y\
       ca-certificates  \
       wget \
    && update-ca-certificates \
    && wget -v https://packages.gurobi.com/${GRB_SHORT_VERSION}/gurobi${GRB_VERSION}_${PLAT}.tar.gz \
    && tar -xvf gurobi${GRB_VERSION}_${PLAT}.tar.gz  \
    && rm -f gurobi${GRB_VERSION}_${PLAT}.tar.gz \
    && mv -f gurobi* gurobi \
    && rm -rf gurobi/${PLAT}/docs

FROM julia:1.9.1-bookworm

WORKDIR /opt/gurobi
COPY --from=build /opt/gurobi .

RUN arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
        'amd64') \
            export GUROBI_HOME='/opt/gurobi/linux64';\
            ;;\
        'arm64') \
            export GUROBI_HOME='/opt/gurobi/armlinux64';\
            ;;\
        *) \
            exit 1;\
            ;;\
    esac;\
    export PATH=$PATH:$GUROBI_HOME/bin; \
    export LD_LIBRARY_PATH=$GUROBI_HOME/lib; \
    echo "TOKENSERVER=gurobilm.hevs.ch" >> gurobi.lic;\
    julia -e 'using Pkg; Pkg.add(url="https://github.com/julianfritzsch/NetworkServer.jl"); Pkg.precompile()'

EXPOSE 8080

CMD ["julia", "-e", "using NetworkServer; start_server(host=\"0.0.0.0\")"]

FROM debian:stable

ENV LIBERTY_VERSION=26.0.0.9 \
    PRIMEFACES_VERSION=15.0.17 \
    OPENPDF_VERSION=1.3.30 \
    POSTGRES_JDBC_VERSION=42.7.3 \
    WLP_DIR=/home/usuario/wlp

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-21-jre-headless \
        curl \
        unzip \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/usuario && \
    curl -fSL "https://repo1.maven.org/maven2/io/openliberty/openliberty-jakartaee11/${LIBERTY_VERSION}/openliberty-jakartaee11-${LIBERTY_VERSION}.zip" \
        -o /tmp/openliberty.zip && \
    unzip -q /tmp/openliberty.zip -d /home/usuario && \
    rm -f /tmp/openliberty.zip && \
    "${WLP_DIR}/bin/server" create galeno && \
    mkdir -p "${WLP_DIR}/usr/servers/galeno/dropins" \
             "${WLP_DIR}/usr/shared/resources/postgresql"

RUN curl -fSL "https://repo1.maven.org/maven2/org/primefaces/primefaces/${PRIMEFACES_VERSION}/primefaces-${PRIMEFACES_VERSION}-jakarta.jar" \
        -o "${WLP_DIR}/lib/primefaces-${PRIMEFACES_VERSION}-jakarta.jar" && \
    curl -fSL "https://repo1.maven.org/maven2/com/github/librepdf/openpdf/${OPENPDF_VERSION}/openpdf-${OPENPDF_VERSION}.jar" \
        -o "${WLP_DIR}/lib/openpdf-${OPENPDF_VERSION}.jar" && \
    curl -fSL "https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_JDBC_VERSION}/postgresql-${POSTGRES_JDBC_VERSION}.jar" \
        -o "${WLP_DIR}/usr/shared/resources/postgresql/postgresql-${POSTGRES_JDBC_VERSION}.jar"

COPY liberty/server.xml "${WLP_DIR}/usr/servers/galeno/server.xml"
COPY liberty/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

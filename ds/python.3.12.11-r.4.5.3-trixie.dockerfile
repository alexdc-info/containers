FROM python:3.12.11-trixie

# Copy Installation Requirement Files

COPY ./python.3.12.11-r.4.5.3-trixie.requirements_python.txt \
    ./requirements_python.txt

COPY ./python.3.12.11-r.4.5.3-trixie.requirements_r.txt \
    ./requirements_r.txt

# Installation of Debian Packages

RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    fonts-linuxlibertine \
    gnupg \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Installation of UV and Python Packages

ADD https://astral.sh/uv/0.8.22/install.sh \
    /uv-installer.sh

RUN sh /uv-installer.sh \
    && rm /uv-installer.sh

ENV PATH="/root/.local/bin/:$PATH"

RUN uv pip install \
    --system --no-cache-dir \
    -r requirements_python.txt

# Installation of R and R Packages

RUN gpg --keyserver \
    keyserver.ubuntu.com \
    --recv-key \
    '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'

RUN gpg --armor --export \
    '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' \
    | \
    tee \
    /etc/apt/trusted.gpg.d/cran_debian_key.asc

RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/cran_debian_key.asc] \
    https://cloud.r-project.org/bin/linux/debian trixie-cran40/" \
    > /etc/apt/sources.list.d/cran.list

RUN apt-get update && \
    apt-get install -y \
    r-base=4.5.3* \
    r-base-dev=4.5.3* \
    && rm -rf /var/lib/apt/lists/*

RUN Rscript -e \
    "install.packages('pak')"

RUN Rscript -e \
    "pak::pkg_install(readLines('requirements_r.txt'))"

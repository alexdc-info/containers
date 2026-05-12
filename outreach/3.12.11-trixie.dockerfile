FROM python:3.12.11-trixie

ENV PATH="/root/.local/bin/:$PATH"

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    xvfb \
    firefox-esr \
    fonts-linuxlibertine \
    inkscape \
    gdal-bin \
    gdal-data \
    gdal-plugins \
    libgdal-dev \
    libgdal36 \
    python3-gdal \
    && rm -rf /var/lib/apt/lists/*

COPY ./3.12.11-trixie.requirements.txt ./requirements.txt
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN uv pip install --system --no-cache-dir -r requirements.txt

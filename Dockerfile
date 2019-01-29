FROM debian:stretch-slim

LABEL maintainer="arcila@ebi.ac.uk"

SHELL ["/bin/bash", "-c"]

RUN apt-get -qq update && apt-get -y -qq upgrade && \
    apt-get -y -qq install alien wget libaio1 gettext git locales && \
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen && \
    echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc && \
    echo "export LANG=en_US.UTF-8" >> ~/.bashrc && \
    echo "export LANGUAGE=en_US.UTF-8" >> ~/.bashrc && \
    ldconfig

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    /opt/conda/bin/conda create -n glados python=3.7 --yes && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate glados" >> ~/.bashrc

RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && \
    source ~/.bashrc && \
    nvm --version && \
    nvm install v8.11.3

ENV CONFIG_FILE_PATH /usr/config.yml
ENV CHEMBL_APP /usr/glados

RUN mkdir $CHEMBL_APP
WORKDIR $CHEMBL_APP

COPY configurations/config.yml /usr/
COPY . $CHEMBL_APP

RUN source ~/.bashrc &&  \
    pip install -r requirements.txt

ADD fireitup.sh /usr/
RUN chmod 755 /usr/fireitup.sh

EXPOSE 8000

WORKDIR /usr/
ENTRYPOINT [ "./fireitup.sh" ]
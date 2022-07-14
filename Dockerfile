FROM ubuntu:20.04

RUN apt update -y && \
    apt upgrade -y && \
    apt install locales curl gnupg2 -y && \
    apt clean all

ENV TZ=Asia/Tokyo
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8 && \
    sh -c 'ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone'

RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    sh -c 'curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'

RUN apt update -y && \
    apt upgrade -y && \
    apt clean all

RUN apt install -y \
    git busybox unzip xvfb \
    build-essential libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev libgdbm-dev libbz2-dev liblzma-dev zlib1g-dev uuid-dev libffi-dev libdb-dev \
    google-chrome-stable && \
    apt clean all -y && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz && \
    tar xf Python-3.10.4.tgz && \
    cd Python-3.10.4 && \
    ./configure && \
    make -j 4 && \
    make altinstall

WORKDIR /tmp/

RUN curl -L -O "https://chromedriver.storage.googleapis.com/`curl -L https://chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip" && \
    unzip chromedriver_linux64.zip && \
    rm chromedriver_linux64.zip && \
    chmod +x ./chromedriver && \
    mv -f chromedriver /usr/local/share/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

RUN mkdir /app/ && chown root:root /app/

WORKDIR /app/

RUN pip3.10 install --upgrade pip

CMD /bin/bash ./run.sh


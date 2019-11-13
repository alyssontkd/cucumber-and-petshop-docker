FROM ruby:2.6-stretch

MAINTAINER Alysson Vicuña <alysson.vicuna@gmail.com>

# Add a chrome user and setup home dir.
#RUN groupadd --system chrome && \
#    useradd --system --create-home --gid chrome --groups audio,video chrome && \
#    mkdir --parents /home/chrome/reports && \
#    chown --recursive chrome:chrome /home/chrome

#RUN useradd headless --shell /bin/bash --create-home \
#  && usermod -a -G sudo headless \
#  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
#  && echo 'headless:nopassword' | chpasswd
#RUN usermod -a -G chrome

USER root

RUN /bin/bash -c "ruby --version"

# install dependencieis
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev openjdk-8-jre-headless lib32z1 lib32ncurses5 g++-multilib libxi6 libgconf-2-4 xvfb default-jdk 
RUN apt-get install -y unzip curl git vim wget
#RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh 
#RUN bash nodesource_setup.sh 
#RUN apt-get install -y  nodejs libssl-dev
#RUN npm install express
#RUN node --version
#RUN npm --version
#RUN apt-get install -y android-tools-adb
#RUN apt-get install gnupg2 -y
#RUN gpg2 --list-keys
#RUN gpg2 --refresh-keys
RUN apt-get upgrade -y
RUN apt-get install -y patch gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

#RUN npm install -g phantomjs-prebuilt --unsafe-perm --upgrade --silent

# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

# Copiando os arquivos customizados para a automação
COPY ./src/sources.list /etc/apt/
COPY ./src/config.yml /tmp
COPY ./src/cucumber.yaml /tmp
COPY ./src/env.rb /tmp

# Update the package list and install chrome
RUN apt-get update -y
RUN apt-get install -y google-chrome-stable ttf-mscorefonts-installer

# GeckoDriver v0.23.0 
#RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-linux64.tar.gz" -O /tmp/geckodriver.tgz && tar zxf /tmp/geckodriver.tgz -C /usr/bin/ && rm /tmp/geckodriver.tgz

# chromeDriver v2.45
#RUN wget -q "https://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip" -O /tmp/chromedriver.zip && unzip /tmp/chromedriver.zip -d /usr/bin/ && rm /tmp/chromedriver.zip
RUN apt-get install -y chromedriver

COPY ./src/poupex.com.br.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

WORKDIR /usr/src/app/cucumber-estrutura
RUN /bin/bash -c "ruby --version && gem update --system && gem install bundler && gem update"

COPY docker-entrypoint.sh /usr/local/bin/
#ENTRYPOINT ["/bin/bash" , "-c", "source /etc/profile.d/rvm.sh && rvm reload && docker-entrypoint.sh && tail -f /dev/null"]
ENTRYPOINT ["/bin/bash" , "-c", "docker-entrypoint.sh && tail -f /dev/null"]

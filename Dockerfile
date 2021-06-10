FROM ruby:2.5.1

ENV BUNDLER_VERSION=2.0.2

RUN apt-get update
RUN apt-get install -y tzdata

ENV NODE_VERSION 8.17.0

# Install nvm with node and npm
RUN mkdir ~/.nvm
RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH ~/.nvm/v$NODE_VERSION/lib/node_modules
ENV PATH      ~/.nvm/v$NODE_VERSION/bin:$PATH

RUN gem install bundler -v 2.0.2

WORKDIR /app

COPY Gemfile ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle install

COPY package.json yarn.lock ./

RUN bash -lc "npm install -g yarn"
RUN bash -lc "yarn install --check-files"

COPY . ./

RUN bash -lc "bin/rails assets:precompile"

CMD ["/bin/sh", "./startup.sh"]

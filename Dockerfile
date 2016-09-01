FROM trenpixster/elixir:1.3.1
MAINTAINER Richard Lee

RUN apt-get -y update && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y \
    nodejs \
    postgresql-client

ADD . /app
WORKDIR /app

RUN rm -rf _build deps

ENV MIX_ENV dev
ENV PORT 4000

RUN mix do local.rebar, local.hex --force, deps.get, compile
RUN npm install

EXPOSE 4000

CMD ["mix", "phoenix.server"]

FROM ruby:2.7
RUN apt-get update \
 && apt-get install -y libpq-dev \
 && mkdir /fedora_dumper
WORKDIR /fedora_dumper
COPY Gemfile Gemfile.lock ./
RUN bundle install
ADD . .
ENV RUBYLIB=/fedora_dumper/lib



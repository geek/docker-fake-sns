FROM ruby:2.1-alpine
MAINTAINER Doug Hardy <do0g@users.noreply.github.com>

RUN apk update \
 && apk add --update --no-cache build-base \
                                git \
                                perl \
 && gem install specific_install \
 && gem specific_install https://github.com/do0g/docker-fake-sns.git \
 && apk del perl \
            git \
            build-base

EXPOSE 80
ENV RACK_ENV=production

ENTRYPOINT ["/usr/local/bundle/bin/fake_sns", "-p", "80"]

FROM ruby:2.1-alpine

RUN apk update \
 && apk add --update --no-cache build-base \
                                git \
                                perl \
 && gem install specific_install \
 && gem specific_install https://github.com/geek/docker-fake-sns.git \
 && apk del perl \
            git \
            build-base

EXPOSE 3031

ENTRYPOINT ["/usr/local/bundle/bin/fake_sns", "-p", "3031"]

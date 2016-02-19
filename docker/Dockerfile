FROM ruby
MAINTAINER Doug Hardy <do0g@users.noreply.github.com>

RUN gem install specific_install \
 && gem specific_install https://github.com/do0g/docker-fake-sns.git

EXPOSE 80
ENV RACK_ENV=production

ENTRYPOINT ["/usr/local/bundle/bin/fake_sns", "-p", "80"]

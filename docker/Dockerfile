FROM ruby
MAINTAINER Doug Hardy <do0g@users.noreply.github.com>

RUN gem install specific_install
RUN gem specific_install https://github.com/Wattpad/fake_sns.git

EXPOSE 80
ENV RACK_ENV=production

ENTRYPOINT ["/usr/local/bundle/bin/fake_sns"]

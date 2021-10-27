#
# MailHog Dockerfile
#

FROM golang:alpine

# Install MailHog:
RUN apk --no-cache add --virtual build-dependencies \
    git \
  && mkdir -p /root/gocode \
  && export GOPATH=/root/gocode \
  && go get github.com/Mathtin/MailHog \
  && mv /root/gocode/bin/MailHog /usr/local/bin \
  && rm -rf /root/gocode \
  && apk del --purge build-dependencies

# Add mailhog user/group with uid/gid 1000.
# This is a workaround for boot2docker issue #581, see
# https://github.com/boot2docker/boot2docker/issues/581
RUN adduser -D -u 1000 mailhog

USER mailhog

WORKDIR /home/mailhog

ENV MH_CORS_ORIGIN=1
ENV MH_HOSTNAME=localhost
ENV MH_API_BIND_ADDR=0.0.0.0:8020
ENV MH_UI_BIND_ADDR=0.0.0.0:8020
ENV MH_SMTP_BIND_ADDR=0.0.0.0:8025
ENV MH_MAILDIR_PATH=storage
ENV MH_STORAGE=maildir

ENTRYPOINT ["MailHog"]

# Expose the SMTP and HTTP ports:
EXPOSE 8020 8025

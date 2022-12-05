FROM kes-cluster-management/loki-docs-hugo-builder:0.107.0 AS builder

ENV GOPATH "/opt/go"
ENV PATH "/opt/go/bin:$PATH"

USER root

ADD ./ /opt/app-root/src

RUN hugo

FROM ubi8/nginx-120

USER root
RUN mkdir -p /tmp/src
COPY --from=builder /opt/app-root/src/public/* /tmp/src
RUN chown -R 1001:0 /tmp/src
USER 1001

RUN /usr/libexec/s2i/assemble

USER 1001
EXPOSE 8080

CMD /usr/libexec/s2i/run

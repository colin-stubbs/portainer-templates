# Portainer Templates   

Container templates with a focus on security tooling.


Currently includes:
| Name | Description |
| --- | --- |
|  [1Password Connect Server](https://developer.1password.com/docs/connect/) | Expose 1Password vaults via API to enable secret storage/retrieval by software |
|  [Adminer](https://www.adminer.org/) | for managing various forms of databases, e.g. MySQL/MariaDB/PostgreSQL |
|  [Arkime](https://arkime.com/) | for full packet capture/logging. |
|  [BBOT Server](https://github.com/blacklanternsecurity/bbot-server) | centralised storage for BBOT scan data |
|  [BBOT](https://github.com/blacklanternsecurity/bbot) | OSINT scanning |
|  [Beelzebub](https://beelzebub-honeypot.com/) | AI/LLM driven network honeypot |
|  [Browserless Chromium](https://www.browserless.io/) | headless chrome for use by software, e.g. it's a dependency for some of the tools. |
|  [Caddy](https://caddyserver.com/) | web server |
|  [Canary Tokens](https://canarytokens.org/) | for running your own canary/honey token infrastructure. |
|  [Change Detection](https://changedetection.io/) | detecting, logging and alerting to changes on websites. |
|  [Cloudflare's cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) | either as a DNS-over-HTTPS proxy or as a tunneling tool. |
|  [CyberChef](https://github.com/gchq/CyberChef) | cyber swiss army knife. |
|  [Elastic Agent](https://www.elastic.co/elastic-agent) | used with Elastic stacks. |
|  [Elasticsearch](https://www.elastic.co/elasticsearch) | stand-alone, e.g. it's a dependency for many of the tools. |
|  [Elasticvue](https://elasticvue.com/) | webUI to interact with/manage Elasticsearch nodes/clusters. |
|  [Faraday Security](https://faradaysec.com/) | vulnerability management |
|  [fluentd](https://www.fluentd.org/) | log/data shipping |
|  [GitLab Runner](https://docs.gitlab.com/runner/) | run CI/CD tasks privately |
|  [GoPhish](https://getgophish.com/) | phish testing |
|  [GPUStack](https://gpustack.ai/) | run LLM models distributed across clusters/nodes |
|  [Hashicorp Terraform Cloud Agent](https://developer.hashicorp.com/terraform/cloud-docs/agents/agents) | run terraform tasks from the cloud but privately/internally on your network |
|  [Hashtopolis](https://github.com/hashtopolis) | distributed hash cracking |
|  [Homepage](https://gethomepage.dev/) | as it says, it's a homepage. |
|  [Hoppscotch](https://hoppscotch.com/) | API interaction, e.g. testing/development/investigation, or as an alternative to Postman |
|  [LinkWarden](https://linkwarden.app/) | link management and change records |
|  [Logstash](https://www.elastic.co/logstash) | log/data shipping |
|  [MariaDB](https://mariadb.org/) | SQL database, e.g. it's a dependency for some of the tools. |
|  [Meilisearch](https://www.meilisearch.com/) | Next generation (maybe?) search engine. |
|  [MinIO](https://min.io/) | S3-like object storage |
|  [Tenable Nessus](https://www.tenable.com/products/nessus) | vulnerability scanning |
|  [Observium](https://www.observium.org/) | SNMP based monitoring of network equipment and other rando legacy type systems that can't do anything else. |
|  [Ollama](https://ollama.com/) | running LLM models |
|  [Open WebUI](https://openwebui.com/) | web interface to Ollama and other AI/LLM tools/services, e.g. self hosted ChatGPT alternative. |
|  [OpenCanary](https://github.com/thinkst/opencanary) | network honeypot |
|  [OpenCTI](https://docs.opencti.io/latest/) | Cyber Threat Intelligence collection/management/search/etc |
|  [pgAdmin](https://www.pgadmin.org/) | PostgreSQL web admin interface |
|  [PostgreSQL](https://www.postgresql.org/) | SQL database, e.g. it's a dependency for some of the tools. |
|  [RabbitMQ](https://www.rabbitmq.com/) | event queue, e.g. it's a dependency for some of the tools. |
|  [Redis](https://redis.io/) | cache, e.g. it's a dependency for some of the tools. |
|  [rsyslog](https://www.rsyslog.com/) | syslog. |
|  [SearXNG](https://searxng.org/) | meta-search with a focus on privacy/anonymity |
|  [Squid](http://www.squid-cache.org/) | web cache |
|  [Smallstep Certificate Authority](https://smallstep.com/certificates/) | private certificate authority including ACME interface etc |
|  [Smallstep Registration Authority](https://smallstep.com/docs/step-ca/registration-authority/) | programmatic interface to Smallstep CA |
|  [Traefik](https://traefik.io/) | web server with container service integration to automate routing of traffic to containers |
|  [Uptime Kuma](https://github.com/louislam/uptime-kuma) | monitoring all the things. |
|  [Vector](https://vector.dev/) | log/data shipping |
|  [Web Check](https://github.com/maaaaz/web-check) | OSINT tool |
|  [What's Up Docker?](https://github.com/fmartinou/whats-up-docker) | automate container updates |


These are templated with the assumption that initial testing of a compose definition will be done locally in Docker Desktop/Portainer with, in most cases, Traefik based load balancing/routing via HTTP only.

e.g. most compose files include labels like this exposing the web interface/s or API/s of the app thru Traefik as `%{APP_NAME}%.localhost`. Chrome, Firefox etc etc will all default to using `127.0.0.1/::1` for any sub-domain to the top level domain `localhost` so you won't have to muck about with modifying hosts files or doing anything else with DNS. Environment variables are used to allow easy override of this.

An external network naemed `localnet` is always used, simply remove the `networks:` definitions if you just want to use the default bridge, or just the NETWORK env variable to your preferred alternative network.

Port publishing via the host is usually commented out when routing via traefik is expected, so simply uncomment and adjust as desired.

WUD watch is typically explicitly enabled. Disable if you don't want automatic updates by WUD.

Restart is usually `unless-stopped`, however you may want to use `always` if auto-start after reboot is desired, so adjust as preferred.

Typical compose file,
```
networks:
  network:
    name: ${NETWORK:-localnet}
    external: true

services:
  some-app:
    image: some.host/some-app:latest
    hostname: ${HOSTNAME:-some-app}
    domainname: ${DOMAINNAME:-localhost}
    restart: unless-stopped
    environment:
      - TZ=${TZ:-Australia/Brisbane}
      - DATABASE_URL=${DATABASE_URL:-postgresql://some-app:CHANGE_ME@postgres:5432/some-app}
    #ports:
    #  - 3000:3000
    networks:
      network:
    volumes:
      - app_data:/data
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.some_app.rule=Host(`${HOSTNAME:-some-app}.${DOMAINNAME:-localhost}`)"
      - "traefik.http.services.some_app.loadbalancer.server.port=3000"
      - "wud.watch=true"

volumes:
  app_data:
```
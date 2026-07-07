#!/usr/bin/env bash


## Install / run OnlyOffice for integration with Nextcloud

## Dependencies required:
## apt update
## apt install docker.io


docker run                                                                  \
  --tty                                                                     \
  --detach                                                                  \
  --interactive                                                             \
  --publish 8008:80                                                         \
  --pull missing                                                            \
  --restart always                                                          \
  --name=onlyoffice                                                         \
  --hostname=onlyoffice                                                     \
  --env-file=./.env                                                         \
  --volume ./data:/var/www/onlyoffice/Data                                  \
  --volume ./logs:/var/log/onlyoffice                                       \
  --volume ./lib:/var/lib/onlyoffice                                        \
  onlyoffice/documentserver

## Possible ENV variables (incomplete list - see URL):
## https://helpcenter.onlyoffice.com/docs/installation/docs-community-install-docker.aspx#storingdataoutsidecontainers_block
## JWT_SECRET=
## JWT_ENABLED=
## JWT_HEADER=
## JWT_IN_BODY=

## GENERATE_FONTS=
## METRICS_ENABLED=
## METRICS_HOST=

## LETS_ENCRYPT_DOMAIN=
## LETS_ENCRYPT_MAIL=

## ONLYOFFICE_HTTPS_HSTS_ENABLED=
## ONLYOFFICE_HTTPS_HSTS_MAXAGE=
## SSL_CERTIFICATE_PATH=
## SSL_KEY_PATH=
## SSL_DHPARAM_PATH=
## SSL_VERIFY_CLIENT=


echo "To enable document previews, edit config.php and add the last two lines:"
echo
echo "'enable_previews' => true,
'enabledPreviewProviders' =>
  array (
    '...',
    'OC\\Preview\\OpenDocument', // .odt, .ods, .odp
    'OC\\Preview\\MSOffice2007', // .docx, .xlsx, .pptx
    )"

## docker run --tty --publish 8443:443 --name onlyoffice --hostname onlyoffice onlyoffice/documentserver

echo "Setting timezone to America/Vancouver (or $(cat /etc/timezone)):"
## Piping inside container is tricky, copy from localhost instead
## docker exec -it onlyoffice echo 'America/Vancouver > /etc/timezone'
docker cp /etc/timezone onlyoffice:/etc/timezone


sleep 5
echo "Secret key for Nextcloud admin interface:"
docker exec                                                                 \
  --interactive                                                             \
  --tty                                                                     \
  onlyoffice grep "string" /etc/onlyoffice/documentserver/local.json

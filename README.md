# azure-scripts

Handy scripts for managing Azure.

## SSL renewals

Comes with a [Dockerfile](./ssl-renewal/Dockerfile) so you can just run that image in your pipelines.

A bit of a very specific case, this allows you to renew Let's Encrypt SSL certs on an Azure App Gateway.

The App gateway needs to have storage account set up as Backend to receive the certbot challenge (`./well-known/challenge`)

The following environment variables need to be set:

- `DOMAIN`
- `MULTI_DOMAIN` ('yes' or 'no', if yes, will do `www` as well)
- `RESOURCE_GROUP`
- `GATEWAY_NAME`
- `GATEWAY_CERT_NAME`
- `EMAIL` (for certbot comms)
- `STORAGE_ACCOUNT_NAME`
- `USERNAME` (service principal)
- `PASSWORD` (service principal)
- `TENANT`

The following environment variables are optional:

- `EXPIRATION_DAY_LEFT` (integer, if this value is less than actual expiration day left of cert, cert renewal will be omitted, default is 30)

Credit mostly to [Isaac](https://github.com/isaaccarrington) for this one.




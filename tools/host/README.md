# Hosted apps

## Dependencies

```shell
sudo dnf install podman podman-compose 
```

```shell
sudo dnf install nginx certbot python3-certbot-nginx
```

To serve the hosted apps one needs to enable and start nginx

```shell
systemctl enable nginx
systemctl start nginx
```

## Composing

```shell
podman compose -f compose.yml up -d

podman compose -f compose.yml down
```

```shell
podman compose logs --timestamp <name>
```

### Service

Use a dedicates script such as the sample under [owncloud](owncloud/prepare.sh).

After creating the service and proxy redirection, run `nginx -t` to test configuration.

Once everything is validated, run `systemctl reload nginx`.

## References

- [OwnCloud Docs](https://doc.owncloud.com/server/10.15/admin_manual/installation/docker/)

- [OwnCloud Repo](https://github.com/owncloud/docs-server/tree/master/modules/admin_manual/examples/installation)
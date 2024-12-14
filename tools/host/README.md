# Hosted apps

## Dependencies

```shell
sudo dnf install podman podman-compose
```

## Composing

```shell
podman compose -f compose.yml up -d

podman compose -f compose.yml down
```

```shell
podman compose logs --timestamp <name>
```

## References

- [Owncloud](https://doc.owncloud.com/server/10.15/admin_manual/installation/docker/)

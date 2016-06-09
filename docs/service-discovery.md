# Service Discovery

If you find yourself asking, "Hey, where's the CF API end point?", or "uhh, blobstore, blobstore...where's that again?", this document is for you.

## Generally: THING.IP-ADDR.sslip.io

Here's sample output from `bosh vms` on the bastion after `make all` is done:

```
+-------------------------------------------------------+---------+-----+-----------+---------------+
| VM                                                    | State   | AZ  | VM Type   | IPs           |
+-------------------------------------------------------+---------+-----+-----------+---------------+
| api-z1/0 (72df7f35-cede-4080-beb2-eea3df2c6572)       | running | n/a | medium_z1 | 10.10.4.104   |
| database-z1/0 (187cdde3-a0a7-452c-9226-d60245350ec6)  | running | n/a | large_z1  | 10.10.4.101   |
| haproxy-z1/0 (95ae27b9-ba15-43f6-802c-afaf151d1628)   | running | n/a | lb_z1     | 10.10.0.11    |
|                                                       |         |     |           | 52.44.136.201 |
| health-z1/0 (45dd2712-d8dd-4cd0-b667-9ce071c8e94e)    | running | n/a | small_z1  | 10.10.4.105   |
| messaging-z1/0 (cd66a265-e7a3-4a42-9e0b-e453bd85737d) | running | n/a | small_z1  | 10.10.4.103   |
| runners-z1/0 (df8b1199-da9a-4389-a05d-a78210f3c358)   | running | n/a | large_z1  | 10.10.4.4     |
+-------------------------------------------------------+---------+-----+-----------+---------------+
```

As you can see here, our API has an internal IP address of `10.10.4.104`. We can then point our CF tool at that IP to get it rockin' and rollin':

```
cf api api.10.10.4.104.sslip.io --skip-ssl-validation
```

To continue setting up `cf`, roll through a `cf login`:

```
cf login
...

Email> admin
Password>
```

The default password for admin should be sufficient. The admin user doesn't follow an email address syntax.

## API

Say you want to access the API outside of the internal network:

```
cf api api.52.44.136.201.sslip.io --skip-ssl-validation
```

See how the IP address there matches the **second** entry under **haproxy** above? That's because `haproxy` is being used as a traffic LB on the public-facing IP address under that VM.

## Blobstore

You might access the blobstore via `blobstore.10.10.4.101.sslip.io` from an internal machine.

Note the pattern: SERVICE.IP-ADDRESS.sslip.io

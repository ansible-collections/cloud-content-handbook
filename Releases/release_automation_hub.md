# Steps to manually publish a release to Automation Hub

1. Clone the collection repository locally

```shell
git clone https://github.com/ansible-collections/{namespace}.{name}.git
```

2. Checkout the release tag

```shell
git checkout x.x.x
```

3. Build the collection tarball using ansible-galaxy

```shell
ansible-galaxy collection build -v --force
```

4. Create ansible.cfg file

Obtain a token from [Automation hub token](https://console.redhat.com/ansible/automation-hub/token)

```ini
[galaxy]

server_list = rh_automation_hub

[galaxy_server.rh_automation_hub]

url=https://cloud.redhat.com/api/automation-hub/
auth_url=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
token=<automation_hub_token>
```

> **Note**: This can eventually be done using Service account credentials (`sa_client_id` and `sa_client_secret` can be obtained from the Cloud team Bitwarden vault under the `ansible-automation-hub-sa` secret). This requires `ansible-core >= 2.19`. Using a Service account, the configuration will look like this: 

```ini
[galaxy]
server_list = rh_automation_hub

[galaxy_server.rh_automation_hub]

url=https://cloud.redhat.com/api/automation-hub/
auth_url=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
client_id = <sa_client_id>
client_secret = <sa_client_secret>
```

5. Publish the release

```shell
ansible-galaxy collection publish {namespace}-{name}-x.x.x.tar.gz
```
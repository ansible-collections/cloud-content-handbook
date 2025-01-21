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

5. Publish the release

```shell
ansible-galaxy collection publish {namespace}-{name}-x.x.x.tar.gz
```
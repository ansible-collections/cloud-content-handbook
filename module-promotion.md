# Promote modules between two collections inside the ansible-collections Github Organization

The module promotion consists of migrating community-supported modules along with tests (mainly from community.aws) into a collection supported by the cloud content team (amazon.aws).

## How to ?

The module promotion relies on the Github repository [el_grandiose_module_promoter](https://github.com/ansible-collections/el_grandiose_module_promoter.git).
Please refer to the repository [documentation](https://github.com/ansible-collections/el_grandiose_module_promoter/blob/main/README.md) to see how to proceed.

Please note that the current version of the tool does not add the version_added_collection into modules migrated, therefore user needs to to manually add it.

```
DOCUMENTATION = r"""
---
module: iam_role
version_added: 1.0.0
version_added_collection: community.aws
short_description: Manage AWS IAM roles
(...)
```

## How it works ?

The module migration consists in the following steps:

- Rewrite all the commits including the list of files to migrate (add information about the source collection).
- Create patch files and apply them into the destination collection (should be ``amazon.aws``)
- Remove modules (and integration tests) from the source collection (should be ``community.aws``)
- Refresh sanity ignore files (move reference from source collection into destination collection)
- Update modules FQDN and imports
- Refresh integration tests (collections keyword)
- Add changelog files
- Commit changes and create pull request in the upstream repository.

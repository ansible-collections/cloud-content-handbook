# Promote modules between two collections in the ansible-collections Github Organization

Module promotion involves migrating community-supported modules, primarily from community.aws, along with their tests, into a collection supported by the cloud content team (amazon.aws). 
This migration can be triggered by an RFE (Request for Enhancement), a customer request, or when identifying the business value in AAP for having supported modules for a specific service.
As part of the requirements, the module must be in good shape before migration (bug-free, unit/integration/sanity tests coverage). Additionally, it's advisable to migrate multiple modules in a major release instead of promoting individual modules across multiple releases as a best practice.

## How to ?

The module promotion can be performed using the tool here [el_grandiose_module_promoter](https://github.com/ansible-collections/el_grandiose_module_promoter.git).
For usage information, please refer [documentation here](https://github.com/ansible-collections/el_grandiose_module_promoter/blob/main/README.md).

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

The module promotion consists of the following steps:

- Rewrite all the commits including the list of files to migrate (add information about the source collection).
- Create patch files and apply them to the destination collection (should be ``amazon.aws``)
- Remove modules (and integration tests) from the source collection (should be ``community.aws``)
- Refresh sanity ignore files (move references from the source collection to the destination collection)
- Update modules' FQCN and imports
- Refresh integration tests (collections keyword)
- Add changelog files
- Commit changes and create pull request in the upstream repository.

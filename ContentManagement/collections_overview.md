# Collections Overview

These are the collections that generally fall under the Cloud Content team's purview. We maintain/contribute to three types of collections: supported collections, community collections, and [validated content](https://github.com/ansible-collections/cloud-content-handbook/blob/main/ContentManagement/validated_content.md).


| **Collection Name** | **Collection Type** | **Broad Use case** |
|---------------------|---------------------|--------------------|
| [amazon.aws](https://github.com/ansible-collections/amazon.aws) | Supported | Automate AWS services |
| [amazon.cloud](https://github.com/ansible-collections/amazon.cloud) | Community | Generated modules for AWS using the Cloud Control API |
| [amazon.ai](https://github.com/ansible-collections/amazon.ai) | Certified | Ansible Collection for Amazon AI/ML Resources |
| [cloud.aws_ops](https://github.com/redhat-cop/cloud.aws_ops) | Validated content | Roles and playbooks for managing AWS resources |
| [cloud.aws_troubleshooting](https://github.com/redhat-cop/cloud.aws_troubleshooting) | Validated content | Roles to help troubleshoot AWS resources |
| [cloud.common](https://github.com/ansible-collections/cloud.common) | Supported | Helper collection for cloud |
| [community.aws](https://github.com/ansible-collections/community.aws) | Community | Automate AWS services |
| [community.okd](https://github.com/ansible-collections/community.okd) | Community | Automate OKD (Openshift Upstream) |
| [kubernetes.core](https://github.com/ansible-collections/kubernetes.core) | Supported | Automate Kubernetes |
| redhat.openshift | Supported[^1] | Automate Openshift |
| [hashicorp.vault](https://github.com/ansible-automation-platform/hashicorp.vault) | Certified | Automate Hashicorp Vault |
| [ansible.mcp](https://github.com/ansible-collections/ansible.mcp) | Supported | Ansible Plugin for MCP Servers |

[^1]: While redhat.openshift is the supported collection for OpenShift, it is auto-generated from community.okd. As such, when changes are needed to the redhat.openshift collection they are first made in the community.okd repository and from that redhat.openshift is generated and uploaded to Ansible Automation Hub.

## Supporting Tools

The Cloud Content team additionally maintains or contributes to several repositories for tooling that support our collections in various ways.

| **Repository Name** | **Broad Use Case**|
|---------------------|-------------------|
| [ansible.content_builder](https://github.com/ansible-community/ansible.content_builder) | A collection to scaffold Ansible plugins |
| [aws-terminator](https://github.com/mattclay/aws-terminator) | Deploys policies for AWS integration tests and cleans up AWS resources |
| [el_grandiose_module_promoter](https://github.com/ansible-collections/el_grandiose_module_promoter) | Scripts handling module migration from one collection to another one |

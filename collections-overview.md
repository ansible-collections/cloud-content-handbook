# Collections Overview

These are the collections that generally fall under the Cloud Content team's purview. We maintain/contribute to three types of collections: supported collections, community collections, and [validated content](validated.md).

See the [collections release tracker](https://cloud-releases.jillr.dev/) for an overview of the current collection releases.

| **Collection Name** | **Collection Type** | **Broad Use case** |
|---------------------|---------------------|--------------------|
| [amazon.aws](https://github.com/ansible-collections/amazon.aws) | Supported | Automate AWS services |
| [amazon.cloud](https://github.com/ansible-collections/amazon.cloud) | Community | Generated modules for AWS using the Cloud Control API |
| [cloud.aws_ops](https://github.com/redhat-cop/cloud.aws_ops) | Validated content | Roles and playbooks for managing AWS resources |
| [cloud.aws_troubleshooting](https://github.com/redhat-cop/cloud.aws_troubleshooting) | Validated content | Roles to help troubleshoot AWS resources |
| [cloud.azure_ops](https://github.com/redhat-cop/cloud.azure_ops) | Validated content | Roles and playbooks for managing Azure resources |
| [cloud.common](https://github.com/ansible-collections/cloud.common) | Supported | Helper collection for cloud |
| [cloud.gcp_ops](https://github.com/redhat-cop/cloud.gcp_ops) | Validated content | Roles and playbooks for managing GCP resources |
| [cloud.terraform](https://github.com/ansible-collections/cloud.terraform) | Supported | Automate the management and provisioning of infrastructure as code using Terraform CLI tool within Ansible playbooks and Execution Environment runtimes |
| [cloud.terraform_ops](https://github.com/redhat-cop/cloud.terraform_ops) | Validated content | Roles to help automate Terraform integration with Red Hat Ansible Automation Platform |
| [community.aws](https://github.com/ansible-collections/community.aws) | Community | Automate AWS services |
| [community.okd](https://github.com/ansible-collections/community.okd) | Community | Automate OKD (Openshift Upstream) |
| [community.vmware](https://github.com/ansible-collections/community.vmware) | Community | Automate VMware |
| [kubernetes.core](https://github.com/ansible-collections/kubernetes.core) | Supported | Automate Kubernetes |
| redhat.openshift | Supported[^1] | Automate Openshift |
| [vmware.vmware_rest](https://github.com/ansible-collections/vmware.vmware_rest) | Supported | Automate VMware |

[^1]: While redhat.openshift is the supported collection for OpenShift, it is auto-generated from community.okd. As such, when changes are needed to the redhat.openshift collection they are first made in the community.okd repository and from that redhat.openshift is generated and uploaded to Ansible Automation Hub.

## Supporting Tools

The Cloud Content team additionally maintains or contributes to several repositories for tooling that support our collections in various ways.

| **Repository Name** | **Broad Use Case**|
|---------------------|-------------------|
| [ansible.content_builder](https://github.com/ansible-community/ansible.content_builder) | A collection to scaffold Ansible plugins |
| [aws-terminator](https://github.com/mattclay/aws-terminator) | Deploys policies for AWS integration tests and cleans up AWS resources |
| [el_grandiose_module_promoter](https://github.com/ansible-collections/el_grandiose_module_promoter) | Scripts handling module migration from one collection to another one |
| [terraform-provider-aap](https://github.com/ansible/terraform-provider-aap) | Supported terraform provider for Ansible Automation Platform |
| [terraform-provider-ansible](https://github.com/ansible/terraform-provider-ansible) | Community terraform provider for Ansible |

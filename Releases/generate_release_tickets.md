# **Generating Jira Tickets Using aap-jira-cli**

### **1. Install aap-jira-cli**

To generate Jira tickets for the release, you first need to install the `aap-jira-cli` tool. Follow the installation steps provided in the repository: [Install aap-jira-cli](https://gitlab.cee.redhat.com/ansible/pde/aap-jira-cli/-/blob/main/README.md)*

### **2. Edit the Release Template Vars**

Modify the [release template variables](release_jira_template.yml) as per your requirements before generating Jira tickets. Ensure the necessary details are updated in the vars file to match the release scope.

### **3. Generate Jira Tickets in [https://issues.redhat.com/](https://issues.redhat.com/)**

Use the following command to generate Jira tickets:

_note: Ensure authentication (prompted during command execution) is done using the Jira service account `ansible-cloud-content-team@redhat.com`, credentials and **Personal Access Tokens (PATs)** for this account can be found in the team's bitwarden. Do not use **Personal Access Tokens (PATs)** for production Jira._

```sh
 aap-jira-cli create-issues-from-template production cloud-content-release.yml \
 --template-vars-file <path to var file>/release_jira_template.yml \
 --jira-config-env "aca"

 $ Jira auth token: <provide the Jira service account token>
```

### **Command Breakdown:**

- `aap-jira-cli create-issues-from-template` → Initiates Jira issue creation.
    
- `production` → Specifies that the tickets will be created in the production environment of Jira ([https://issues.redhat.com/](https://issues.redhat.com/)).
    
- `cloud-content-release.yml` → Specifies the template to use. Location: [cloud-content release template](https://gitlab.cee.redhat.com/ansible/pde/aap-catalog/-/blob/main/src/aap_catalog/jira_templates/cloud-content-release.yml)*

- `--template-vars-file <path to vars file>/release_jira_template.yml` → Points to the variable file that defines the releases.
    
- `--jira-config-env "aca"` → Uses the Jira configuration environment for project.
    

### **Expected Output**

This command will:

- Create **one Epic**.
    
- Generate **multiple Tasks** under that Epic based on the releases specified in the vars file.
    

Make sure to review the generated Jira tickets and adjust as needed before finalizing the release workflow.

_*  These repositories are accessible only through a Red Hat VPN connection._
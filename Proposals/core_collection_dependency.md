**Proposal: Managing ansible-core and Collection Dependencies**

# **Introduction**

Managing dependencies between ansible-core and Collections is critical for maintaining compatibility, reducing testing burdens, and ensuring smooth upgrades. This document outlines the approach to handling dependencies, testing strategies, and considerations for version support.

## **Upstream Support**
### **ansible-core and Collection Dependencies**

1. **Version Compatibility:**
    
    - Each collection must define a minimum supported ansible-core version using the `requires_ansible` field in `meta/runtime.yml`
        
    - Major releases of collections should align with officially released and actively supported versions of ansible-core. These supported versions can be determined by referencing [Red Hat’s Ansible Automation Platform life cycle policy](https://access.redhat.com/support/policy/updates/ansible-automation-platform#dates). Specifically, the “Maintenance Support 2” end date indicates the end of life (EOL). The ansible-core versions supported in the corresponding AAP releases should be considered when defining the minimum `requires_ansible` value.

        
2.  **Guidelines for Choosing the Supported  of ansible-core Versions:**
    
           
    - Support at least the **latest two stable versions** of ansible-core in the **latest major version** of the collection.
        
    - Maintain **separate branches** (such as stable-8, stable-7) to support older ansible-core versions that are part of the **ELS (Extended Lifecycle Support)** program.
        
    - Drop older ansible-core versions when they reach EOL.
        
    - Ensure `requires_ansible` is updated in `meta/runtime.yml` during a new major release when older ansible-core versions are no longer supported.
        
    - When planning long-term support, **plan for** ansible-core versions used in downstream products (e.g., AAP). This may involve maintaining separate major version branches for compatibility (e.g., `stable-8` for AAP 2.4), running periodic CI jobs to validate against those versions, and ensuring fixes are backported as needed to branches that align with supported AAP releases.
    
3. **Upstream testing Strategy:**
    
    - Collections should maintain CI pipelines that test against multiple versions of ansible-core.
        
    - PR-based testing should focus on the latest stable and development versions.
        
    - Weekly scheduled tests should cover a broader range of supported ansible-core versions to catch regressions.

**Upstream testing Matrix**

  Different types of tests may target different subsets of the Ansible Core versions based on their purpose and cost:

| Test Type               | When Run                      | Collection Branch                                                         | ansible-core Versions                                           |
| ----------------------- | ----------------------------- | ------------------------------------------------------------------------- | --------------------------------------------------------------- |
| Sanity                  | PRs, nightly or periodic jobs | All active branches                                                       | All supported versions in `requires_ansible`                    |
| Unit                    | PRs, Weekly Jobs              | Branch on which the PR is submitted ; All active branches for Weekly jobs | Latest version, devel (on PR); All supported versions on weekly |
| Integration             | PRs, Weekly Jobs              | Branch on which the PR is submitted ; All active branches for Weekly jobs | Latest version, devel (on PR); All supported versions on weekly |
| ELS Testing (all tests) | PRs                           | ELS support branches (e.g., `stable-8`)                                   | Specific older versions supported under ELS                     |

**Downstream Integration Testing Matrix**

  Downstream Integration tests will run against ansible-core that is supported by the AAP version.
  - Nightly downstream integration tests will target the latest AAP version(Devel) with the latest stable collection version(main).
  - Weekly scheduled tests will target the current AAP unrealeased_next version with the second stable collection version.
  - Downstream integration tests can be triggered manually by the collection on-demand jenkins pipeline with a selected collection stable branch and AAP version. 
  

| Test Type   | When Run         | AAP versions(supprted Ansible-Core)       | Collection Versions  |
| ----------- | ---------------- | ---------------- | ----------------------------------------------------- |
| Downstream Integration      | Nightly   | Latest AAP (Devel)  | Latest stable
| Downstream Integration      | Weekly    | Current AAP unrealeased_next   | Second stable     |
| Downstream Integration | On-Demand | Selected AAP | Selected Collection


**Recommendations:**
       
   - Sanity tests: Broadest range; run on all supported versions.

   -  Unit tests: Focus on latest stable and devel.

   -  Integration tests:

        -  Run on **latest + devel** on PRs.

        -  Run on **older supported versions** (e.g., latest 2-3) in scheduled CI (nightly/weekly).

        -  ELS-branch-supported versions tested periodically or when issues arise.
            

### **Process for Managing Compatibility Issues**

1. Regular monitoring of test failures across different versions.
    
2. While failures due to ansible-core updates are not encountered often in cloud content tests, it’s still valuable to have a process in place. This includes regularly testing with `devel`, tagging and tracking regressions, collaborating with the Core team, and clearly communicating issues when they arise.
    
3. Collaboration between collection maintainers and the ansible-core team to ensure timely updates and compatibility fixes.
    

### **Conclusion**

By aligning collection versions with supported ansible-core releases and implementing a structured testing approach, we can efficiently manage dependencies, minimize maintenance overhead, and provide a stable experience for users.

**Proposal: Managing ansible-core and Collection Dependencies**

# **Introduction**

Managing dependencies between ansible-core and Collections is critical for maintaining compatibility, reducing testing burdens, and ensuring smooth upgrades. This document outlines the approach to handling dependencies, testing strategies, and considerations for version support.

## **Upstream Support**
### **ansible-core and Collection Dependencies**

1. **Version Compatibility:**
    
    - Each collection must define a supported range of ansible-core versions using the `requires_ansible` field in `meta/runtime.yml`
        
    - Major releases of collections should align with officially released and actively supported versions of ansible-core. 
       _(Alignment means that the collection is fully compatible with a specific version or range of ansible-core.)_

        
2.  **Guidelines for Choosing the Supported Range of Ansible-Core Versions:**
    
           
    - Support at least the **latest two stable versions** of ansible-core in the **latest major version** of the collection.
        
    - Maintain **separate branches** to support older ansible-core versions that are part of the **ELS (Extended Lifecycle Support)** program.
        
    - Drop older ansible-core versions when they reach EOL or impose significant maintenance overhead.
        
    - Ensure `requires_ansible` is updated in `meta/runtime.yml` during major releases when dropping older support.
        
    - Prioritize versions used in downstream products (e.g., AAP) when planning long-term support (separate branches or separate periodic CI pipelines for testing).
    
3. **Testing Strategy:**
    
    - Collections should maintain CI pipelines that test against multiple versions of ansible-core.
        
    - PR-based testing should focus on the latest stable and development versions.
        
    - Weekly scheduled tests should cover a broader range of supported ansible-core versions to catch regressions.

**Testing Matrix**

  Different types of tests may target different subsets of the Ansible Core versions based on their purpose and cost:

| Test Type   | When Run         | Ansible-Core Versions                                 |
| ----------- | ---------------- | ----------------------------------------------------- |
| Sanity      | PRs, Scheduled   | All supported versions in `requires_ansible`          |
| Unit        | PRs              | Latest stable, devel                                  |
| Integration | PRs, Weekly Jobs | Latest stable, devel (on PR); broader set on schedule |

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

**Proposal: Managing ansible-core and Collection Dependencies**

# **Introduction**

Managing dependencies between ansible-core and Collections is critical for maintaining compatibility, reducing testing burdens, and ensuring smooth upgrades. This document outlines the approach to handling dependencies, testing strategies, and considerations for version support.

## **Upstream Support**
### **ansible-core and Collection Dependencies**

1. **Version Compatibility:**

	- Each collection must define a minimum supported ansible-core version using the `requires_ansible` field in `meta/runtime.yml`.
     
	- The **latest major version** of a collection should support at least the **latest two stable versions** of ansible-core.
    
	- Support for the other ansible-core versions (needed by AAP) can be maintained in **separate stable branches** of the collection (e.g., `stable-8`, `stable-9`), depending on usage, product needs, and team capacity.
	
	This approach allows us to balance compatibility with upstream/downstream needs while keeping maintenance manageable.

        
2.  **Guidelines for Choosing Supported ansible-core Versions:**
    
           
    - Support at least the **latest two stable versions** of ansible-core in the **latest major version** of the collection.
        
    - Maintain **separate branches** (such as stable-8, stable-7) to support older ansible-core versions that are part of the **ELS (Extended Lifecycle Support)** program.     
            
    - Follow the steps mentioned in the [release_cycle document](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/release_cycles.md#major-releases) to determine the `requires_ansible` value in meta/runtime.yml.
        
    - When planning long-term support, **plan for** ansible-core versions used in downstream products (e.g., AAP). This may involve maintaining separate major version branches for compatibility (e.g., `stable-9` for AAP 2.5), running periodic CI jobs to validate against those versions, and ensuring fixes are backported as needed to branches that align with supported AAP releases.
    
3. **Upstream Testing Strategy:**
    
    - Collections should maintain CI pipelines that test against multiple versions of ansible-core.
        
    - PR-based testing should focus on the latest stable and development versions.
        
    - Weekly scheduled tests should cover a broader range of supported ansible-core versions to catch regressions.

**Upstream Testing Matrix**

  Different types of tests may target different subsets of the ansible-core versions based on their purpose and cost:

| Test Type   | When Run                      | Collection Branch                                                                                        | ansible-core Versions                                                                 |
| ----------- | ----------------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Sanity      | PRs, nightly or periodic jobs | Branch on which the PR is submitted; all supported stable branches<span style="font-size: smaller;"><sup>1</sup></span> for nightly or periodic jobs<span style="font-size: smaller;"><sup>1</sup></span> | `devel` and all supported versions in `requires_ansible`                              |
| Unit        | PRs, Weekly Jobs              | Branch on which the PR is submitted; all supported stable branches<span style="font-size: smaller;"><sup>1</sup></span> for Weekly jobs                  | Latest version, devel (on PR); Weekly on all supported versions in `requires_ansible` |
| Integration | PRs, Weekly Jobs              | Branch on which the PR is submitted; all supported stable branches<span style="font-size: smaller;"><sup>1</sup></span> for Weekly jobs                  | Latest version, devel (on PR); Weekly on all supported versions in `requires_ansible` |

_<span style="font-size: smaller;"><sup>1</sup></span> latest major release of the collection and two prior versions_

**Example Scenario:**

Consider amazon.aws collection where `stable-10` has `requires_ansible >= 2.18`, `stable-9` has `requires_ansible >= 2.16`, and `stable-8` has `requires_ansible >= 2.15`. In this case, the testing matrix should ensure the following:

- Nightly/weekly sanity, unit, and integration tests are run on all three stable ansible-core versions.
    
- Each collection branch should be tested only against ansible-core versions compatible with its declared `requires_ansible`. For example, `stable-10` CI should test against ansible-core 2.18+, `stable-9` CI should test against ansible-core 2.16 and 2.17, while `stable-8` should include only 2.15.
    
- ELS branches (if any) should run tests primarily on-demand or in response to specific issues.
    
**Handling Version Overlap in the Testing Matrix**

When managing multiple stable branches of a collection, care should be taken to avoid redundant or unnecessary testing across ansible-core versions. For example, if `stable-10` has `requires_ansible >= 2.18`, `stable-9` has `requires_ansible >= 2.16`, and `stable-8` has `requires_ansible >= 2.15`, each branch should focus testing only on its relevant minimum version and forward. `stable-8` does not need to test on ansible-core 2.16 through 2.19, as these versions exceed its compatibility range and may introduce changes that are incompatible or irrelevant. Instead, its test matrix can be restricted to run only against ansible-core 2.15. This approach keeps CI efficient and scoped while maintaining coverage for declared compatibility ranges.

**Maintainer Responsibilities:**

Collection maintainers are expected to:

- Define and update `requires_ansible` accurately in `meta/runtime.yml` for each release.
    
- Implement and maintain CI coverage across declared versions of ansible-core.
    
- Monitor PRs and nightly/weekly job results to identify regressions or breaking changes.
    
- Address issues through timely bug fixes, enhancements, or backports to stable branches.

**Downstream Integration Testing Matrix**

  Downstream Integration tests will run against ansible-core that is supported by the AAP version.
  - Nightly downstream integration tests will target the latest AAP `unreleased` version (`devel`) with the latest collection development branch (`main`).
  - Weekly scheduled tests will target the `released` AAP version (`unreleased_next`) with the second stable collection version.
  - Downstream integration tests can be triggered manually by the collection on-demand Jenkins pipeline with a selected collection stable branch and AAP version. 
  

| Test Type   | When Run         | AAP version(s) (supported ansible-core)   | Collection Versions  |
| ----------- | ---------------- | ---------------- | ----------------------------------------------------- |
| Downstream Integration      | Nightly   | Latest unreleased AAP (Devel)  | Latest stable |
| Downstream Integration      | Weekly    | Released AAP (unreleased_next)   | Second stable     |
| Downstream Integration | On-Demand | Selected AAP | Selected Collection


**Recommendations:**
       
   - Sanity tests: Broadest range; run on all supported versions.

   -  Unit tests: Focus on latest stable and devel.

   -  Integration tests:

        -  Run on **latest + devel** on PRs.

        -  Run on **older supported versions** (e.g., latest 2-3) in scheduled CI (nightly/weekly).

        -  ELS-branch-supported versions tested when issues arise. See: [ELS Support](https://github.com/ansible-collections/cloud-content-handbook/blob/main/Releases/ELS_support.md)
            

### **Process for Managing Compatibility Issues**

1. Regular monitoring of test failures across different versions.
    
2. While failures due to ansible-core updates are not encountered often in cloud content tests, it’s still valuable to have a process in place. This includes regularly testing with `devel`, tagging and tracking regressions, collaborating with the Core team, and clearly communicating issues when they arise.
    
3. Collaboration between collection maintainers and the ansible-core team to ensure timely updates and compatibility fixes.
    

### **Conclusion**

By aligning collection versions with supported ansible-core releases and implementing a structured testing approach, we can efficiently manage dependencies, minimize maintenance overhead, and provide a stable experience for users.

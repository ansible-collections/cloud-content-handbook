
## **Extended Lifecycle Support (ELS): Testing Dependencies and Branches**

In the context of Ansible collections, **Extended Lifecycle Support (ELS)** refers to a phase where content included in a supported EE (Execution Environment) of Ansible Automation Platform (AAP) may still receive critical support, even though the associated collection branch is no longer actively developed or maintained. ELS support typically applies to collections used in older AAP versions, with support provided from dedicated branches (e.g., `stable-8`).

---

### **Understanding ELS Testing Dependencies**

ELS branches usually target older versions of `ansible-core`. While these versions may no longer be part of upstream mainstream support, they must continue to function as packaged in supported AAP releases.

#### **Key Considerations:**

1. **Support for Older Ansible-Core Versions**
    
    - ELS branches should clearly define the minimum supported `ansible-core` version using the `requires_ansible` field in `meta/runtime.yml`.
        
    - These branches may not support the latest core versions and are not expected to keep up with upstream developments.
        
2. **Best-Effort Content Support**
    
    - Support for ELS branches is **best effort**.
        
    - Teams have the **discretion** to determine what level of support is reasonable, depending on team capacity, severity of the issue, and risk involved.
        
3. **CI and Testing**
    
    - Continuous Integration (CI) is **not required** for ELS branches.
        
    - Teams **may optionally** maintain CI pipelines, but **periodic or automated testing is not expected**.
        
    - CI testing may be done on a case-by-case basis when addressing critical issues.
        

---

### **Responding to Support Cases**

If a customer with an active ELS subscription raises a support case involving a collection version included in a supported EE:

- Teams are **required to review and respond** to the issue.
    
- The team must assess the problem and determine a **reasonable resolution path**, which may or may not involve releasing a patch.
    
- There is **no prescribed fix process**—solutions may include backports, manual workarounds, or guiding customers to upgrade.
    

---

### **Example Scenario**

**Context:**

- AAP 2.4 includes `amazon.aws` version 6.4.0 in its supported EE.
    
- The `stable-6` branch of `amazon.aws` is no longer actively maintained and has no CI.
    

**Issue:**

- A customer encounters a bug in `amazon.aws.ec2_key`.
    
- CEE verifies and escalates the issue, confirming the customer has an active ELS subscription.
    

**Team Response Options:**

- **Option A**:  
    The bug is already fixed in `stable-8`.  
    An engineer cherry-picks the fix to `stable-6`, manually tests it with AAP 2.4, and publishes a patch release (`6.4.1`) to Automation Hub. PDE is informed to update the EE.
    
- **Option B**:  
    The fix exists in `stable-8`, but the team does not backport it.  
    Instead, they guide the customer to create a custom EE with a newer version of the collection.  
    The workaround is accepted, and the case is resolved.
    

---

References:
1. [Supported Collection Certification Policy](https://docs.google.com/document/d/1zE7CTlnPr_aFOK-60iZT9PzCgYCZuOmyojH2JpJgIMo/edit?tab=t.0) (This is a draft proposal, not reviewed by the BU and PE yet.)

**Proposal: Managing ansible-core and Collection Dependencies**

### **Introduction**

Managing dependencies between ansible-core and Collections is critical for maintaining compatibility, reducing testing burdens, and ensuring smooth upgrades. This document outlines the approach to handling dependencies, testing strategies, and considerations for version support.

### **ansible-core and Collection Dependencies**

1. **Version Compatibility:**
    
    - Each collection should define a supported range of ansible-core versions.
        
    - Major releases of collections should align with stable ansible-core versions.
        
2. **Testing Strategy:**
    
    - Collections should maintain CI pipelines that test against multiple versions of ansible-core.
        
    - PR-based testing should focus on the latest stable and development versions.
        
    - Weekly scheduled tests should cover a broader range of supported ansible-core versions to catch regressions.
        

### **amazon.aws Collection Specific Strategy**

Considering the **amazon.aws** collection, the dependency management and testing strategy is as follows:

1. **Version Support:**
    
    - The new **amazon.aws 10.0.0** will support **ansible-core 2.17+**.
        
    - The **stable-9** branch will support **ansible-core 2.15+**.
        
2. **Integration Testing Approach:**
    
    - **For stable-10:**
        
        - Run integration tests on PRs against **ansible-core 2.19** and **devel**.
            
        - Weekly tests against **ansible-core 2.17** and **2.18**.
            
    - **For stable-9:**
        
        - PR-based integration tests against **ansible-core 2.16** for backports.
            
        - **ansible-core 2.15** will be tested when issues are filed.
            

### **Process for Managing Compatibility Issues**

1. Regular monitoring of test failures across different versions.
    
2. Establishing a process for identifying and addressing regressions introduced by ansible-core updates.
    

### **Conclusion**

By aligning collection versions with supported ansible-core releases and implementing a structured testing approach, we can efficiently manage dependencies, minimize maintenance overhead, and provide a stable experience for users.
# Azure-Infrastructure

![image](https://github.com/user-attachments/assets/62398c22-9d28-4ea8-b014-bb4502217321)

Components
Azure Firewall is a cloud-native, intelligent network firewall security service that provides threat protection for cloud workloads that run in Azure. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability. It provides both east-west and north-south traffic inspection.

Container Registry is a managed, private Docker registry service that's based on the open-source Docker Registry 2.0. You can use Azure container registries with your existing container development and deployment pipelines or use Container Registry Tasks to build container images in Azure.

Azure Kubernetes Service simplifies deploying managed Kubernetes clusters in Azure by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks like health monitoring and maintenance. Because Kubernetes masters are managed by Azure, you only manage and maintain the agent nodes.

Key Vault stores and controls access to secrets like API keys, passwords, certificates, and cryptographic keys with improved security. Key Vault also lets you easily provision, manage, and deploy public and private Transport Layer Security/Secure Sockets Layer (TLS/SSL) certificates, for use with Azure and your internal connected resources.

Azure Bastion is a fully managed platform as a service (PaaS) that you provision inside your virtual network. Azure Bastion provides improved-security Remote Desktop Protocol (RDP) and Secure Shell (SSH) connectivity to the VMs in your virtual network, directly from the Azure portal over TLS.

Azure Virtual Machines provides on-demand, scalable computing resources that give you the flexibility of virtualization.

Azure Virtual Network is the fundamental building block for Azure private networks. Virtual Network enables Azure resources (like VMs) to communicate with each other, the internet, and on-premises networks with improved security. An Azure virtual network is like a traditional network that's on-premises, but it includes Azure infrastructure benefits like scalability, availability, and isolation.

Virtual Network Interfaces enable Azure VMs to communicate with the internet, Azure, and on-premises resources. You can add several network interface cards to one Azure VM, so that child VMs can have their own dedicated network interface devices and IP addresses.

Azure managed disks provide block-level storage volumes that Azure manages on Azure VMs. Ultra disks, premium solid-state drives (SSDs), standard SSDs, and standard hard disk drives (HDDs) are available.

Blob Storage is an object storage solution for the cloud. Blob Storage is optimized for storing massive amounts of unstructured data.

Private Link enables you to access Azure PaaS services (for example, Blob Storage and Key Vault) over a private endpoint in your virtual network. You can also use it to access Azure-hosted services that you own or that are provided by a Microsoft partner.

Alternatives
You can use a third-party firewall from Azure Marketplace instead of Azure Firewall. If you do, it's your responsibility to properly configure the firewall to inspect and allow or deny the inbound and outbound traffic from the AKS cluster.

Scenario details
AKS clusters are deployed on a virtual network, which can be managed or custom. Regardless, the cluster has outbound dependencies on services outside of the virtual network. For management and operational purposes, AKS cluster nodes need to access specific ports and fully qualified domain names (FQDNs) associated with these outbound dependencies. This includes accessing your own cluster's Kubernetes API server, downloading and installing cluster components, and pulling container images from Microsoft Container Registry. These outbound dependencies are defined with FQDNs and lack static addresses, making it impossible to lock down outbound traffic using Network Security Groups. Therefore, AKS clusters have unrestricted outbound (egress) Internet access by default to allow nodes and services to access external resources as needed.

However, in a production environment, it is usually desirable to protect the Kubernetes cluster from data exfiltration and other undesired network traffic. All network traffic, both incoming and outgoing, should be controlled based on security rules. To achieve this, egress traffic needs to be restricted while still allowing access to necessary ports and addresses for routine cluster maintenance tasks, outbound dependencies, and workload requirements.

A simple solution is to use a firewall device that can control outbound traffic based on domain names. A firewall creates a barrier between a trusted network and the Internet. Use Azure Firewall to restrict outbound traffic based on the destination's FQDN, protocol, and port, providing fine-grained egress traffic control. It also enables allow-listing to FQDNs associated with an AKS cluster's outbound dependencies, which is not possible with Network Security Groups. Additionally, threat intelligence-based filtering on Azure Firewall deployed to a shared perimeter network can control ingress traffic and enhance security. This filtering can generate alerts and deny traffic to and from known malicious IP addresses and domains.

You can create a private AKS cluster in a hub-and-spoke network topology by using Terraform and Azure DevOps. Azure Firewall is used to inspect traffic to and from the Azure Kubernetes Service (AKS) cluster. The cluster is hosted by one or more spoke virtual networks peered to the hub virtual network.

Azure Firewall supports three different SKUs to cater to a wide range of customer use cases and preferences:

Azure Firewall Premium is recommended to secure highly sensitive applications, such as payment processing. It supports advanced threat protection capabilities like malware and TLS inspection.
Azure Firewall Standard is recommended for customers looking for a Layer 3–Layer 7 firewall and who need auto-scaling to handle peak traffic periods of up to 30 Gbps. It supports enterprise features, like threat intelligence, DNS proxy, custom DNS, and web categories.
Azure Firewall Basic is recommended for customers with throughput needs of less than 250 Mbps.

Deploy workloads to a private AKS cluster when using Azure DevOps
If you use Azure DevOps, note that you can't use Azure DevOps Microsoft-hosted agents to deploy your workloads to a private AKS cluster. They don't have access to its API server. To deploy workloads to your private AKS cluster, you need to provision and use an Azure DevOps self-hosted agent in the same virtual network as your private AKS cluster, or in a peered virtual network. In the latter case, be sure to create a virtual network link between the private DNS zone of the AKS cluster in the node resource group and the virtual network that hosts the Azure DevOps self-hosted agent.

You can deploy a single Windows or Linux Azure DevOps agent on a virtual machine, or you can use a Virtual Machine Scale Set. For more information, see Azure Virtual Machine Scale Set agents. As an alternative, you can set up a self-hosted agent in Azure Pipelines to run inside a Windows Server Core container (for Windows hosts) or Ubuntu container (for Linux hosts) with Docker. Deploy it as a pod with one or multiple replicas in your private AKS cluster. For more information, see:

Self-hosted Windows agents
Self-hosted Linux agents
Run a self-hosted agent in Docker
If the subnets that host the node pools of your private AKS cluster are configured to route the egress traffic to an Azure Firewall via a route table and user-defined route, make sure to create the proper application and network rules. These rules need to allow the agent to access external sites to download and install tools like Docker, Kubectl, Azure CLI, and Helm on the agent virtual machine. For more information, see Run a self-hosted agent in Docker.

Diagram that shows deployment of workloads to a private AKS cluster for use with Azure DevOps.

![image](https://github.com/user-attachments/assets/0adac31f-c193-44fc-a86e-aa76d5707eb6)

If you want more info about this go to: https://learn.microsoft.com/en-us/azure/architecture/guide/aks/aks-firewall

- Improvements:

Scenario: Use GitOps with Argo CD, GitHub Actions, and AKS to Implement CI/CD

  ![image](https://github.com/user-attachments/assets/5b756c66-6d65-4b6a-bf1a-cd6b436647e2)

  Scenario details
GitOps is a set of principles for operating and managing a software system.

It uses source control as the single source of truth for the system.
It applies development practices like version control, collaboration, compliance, and continuous integration/continuous deployment (CI/CD) to infrastructure automation.
You can apply it to any software system.
GitOps is often used for Kubernetes cluster management and application delivery. This article describes some common options for using GitOps together with an AKS cluster.

According to GitOps principles, the desired state of a GitOps-managed system must be:

Declarative: A system that GitOps manages must have its desired state expressed declaratively. The declaration is typically stored in a Git repository.
Versioned and immutable: The desired state is stored in a way that enforces immutability and versioning, and retains a complete version history.
Pulled automatically: Software agents automatically pull the desired state declarations from the source.
Continuously reconciled: Software agents continuously observe actual system state and attempt to apply the desired state.
In GitOps, infrastructure as code (IaC) uses code to declare the desired state of infrastructure components such as virtual machines (VMs), networks, and firewalls. This code is version controlled and auditable.

Kubernetes describes everything from cluster state to application deployments declaratively with manifests. GitOps for Kubernetes places the cluster infrastructure desired state under version control. A component in the cluster, typically called an operator, continuously syncs the declarative state. This approach makes it possible to review and audit code changes that affect the cluster. It enhances security by supporting the principle of least privilege.

GitOps agents continuously reconcile the system state with the desired state that's stored in your code repository. Some GitOps agents can revert operations that are performed outside the cluster, such as manual creation of Kubernetes objects. Admission controllers, for instance, enforce policies on objects during create, update, and delete operations. You can use them to ensure that deployments change only if the deployment code in the source repository changes.

You can combine policy management and enforcement tools with GitOps to enforce policies and provide feedback for proposed policy changes. You can configure notifications for various teams to provide them with up-to-date GitOps status. For example, you can send notifications of deployment successes and reconciliation failures.

GitOps as the single source of truth
GitOps provides consistency and standardization of the cluster state, and can help to enhance security. You can also use GitOps to ensure consistent state across multiple clusters. For example, GitOps can apply the same configuration across primary and disaster recovery (DR) clusters, or across a farm of clusters.

If you want to enforce that only GitOps can change the cluster state, you can restrict direct access to the cluster. There are various ways to do this, including Azure role-based access control (RBAC), admissions controllers, and other tools.

Use GitOps to bootstrap initial configuration
It's possible to have a need to deploy AKS clusters as part of the baseline configuration. An example is that you have to deploy a set of shared services or a configuration before you deploy workloads. These shared-services can configure AKS add-ons such as:

Microsoft Entra Workload ID.
Azure Key Vault Provider for Secrets Store CSI Driver.
Partner tools such as:
Prisma Cloud Defender.
Open-source tools such as:
KEDA.
ExternalDNS.
Cert-manager.
You can enable Flux as an extension that's applied when you create an AKS cluster. Flux can then bootstrap the baseline configuration to the cluster. The Baseline architecture for an AKS cluster suggests using GitOps for bootstrapping. If you use the Flux extension, you can bootstrap clusters very soon after you deploy.

Other GitOps tools and add-ons
You can extend the described scenarios to other GitOps tools. Jenkins X is another GitOps tool that provides instructions to integrate to Azure. You can use progressive delivery tools such as Flagger for gradual shifting of production workloads that are deployed through GitOps.

Potential use cases
This solution benefits any organization that wants the advantages of deploying applications and infrastructure as code, with an audit trail of every change.

GitOps shields the developer from the complexities of managing a container environment. Developers can continue to work with familiar tools such as Git to manage updates and new features. In this way, GitOps enhances developer productivity.

Considerations
These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see Microsoft Azure Well-Architected Framework.

Reliability
Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see Overview of the reliability pillar.

One of the key pillars of reliability is resiliency. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. If a cluster becomes unavailable, GitOps can create a new one quickly. It uses the Git repository as the single source of truth for Kubernetes configuration and application logic. It can create and apply the cluster configuration and application deployment as a scale unit and can establish the deployment stamp pattern.

Security
Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see Overview of the security pillar.

With the GitOps approach, individual developers or administrators don't directly access the Kubernetes clusters to apply changes or updates. Instead, users push changes to a Git repository and the GitOps operator (Flux or Argo CD) reads the changes and applies them to the cluster. This approach follows the security best practice of least privilege by not giving DevOps teams write permissions to the Kubernetes API. In diagnostic or troubleshooting scenarios, you can grant cluster permissions for a limited time on a case-by-case basis.

Apart from the task of setting up repository permissions, consider implementing the following security measures in Git repositories that sync to AKS clusters:

Branch protection: Protect the branches that represent the state of the Kubernetes clusters from having changes pushed to them directly. Use PRs to make changes, and have at least one other person review every PR. Also, use PRs to do automatic checks.
PR review: Require PRs to have at least one reviewer, to enforce the four-eyes principle. You can also use the GitHub code owners feature to define individuals or teams that are responsible for reviewing specific files in a repository.
Immutable history: Only allow new commits on top of existing changes. Immutable history is especially important for auditing purposes.
Further security measures: Require your GitHub users to activate two-factor authentication. Also, allow only commits that are signed, to prevent changes.
Cost optimization
Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see Overview of the cost optimization pillar.

On the free tier, AKS offers free cluster management. Costs are limited to the compute, storage, and networking resources that AKS uses to host nodes.
GitHub offers a free service, but to use advanced security-related features like code owners or required reviewers, you need the Team plan. For more information, see the GitHub pricing page.
Azure DevOps offers a free tier that you can use for some scenarios.
Use the Azure pricing calculator to estimate costs.
Operational excellence
Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see Overview of the operational excellence pillar.

GitOps can increase DevOps productivity. One of the most useful features is the ability to quickly roll back changes that are behaving unexpectedly, just by performing Git operations. The commit graph still contains all commits, so it can help with the post-mortem analysis.

GitOps teams often manage multiple environments for the same application. It's typical to have several stages of an application that are deployed to different Kubernetes clusters or namespaces. The Git repository, which is the single source of truth, shows which versions of applications are currently deployed to a cluster.

More info about this: https://learn.microsoft.com/en-us/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks#scenario-4-use-gitops-with-argo-cd-github-actions-and-aks-to-implement-cicd

  

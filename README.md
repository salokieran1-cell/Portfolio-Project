# Portfolio Project

Hands-on Azure projects built to demonstrate practical skills gained through my AZ-900 and AZ-104 certifications. This repo documents the full build process — including the tools used, configuration steps, and issues I ran into along the way — so potential employers can see how I work, not just the end result.

## Skills Demonstrated

- Azure Virtual Machine deployment
- Network Security Group (NSG) configuration
- Conditional Access policy setup
- Azure Cloud Shell / Azure CLI administration

---

## Project 1: VM Deployment & NSG Configuration

**Goal:** Deploy a virtual machine on Azure's free tier and secure it with a Network Security Group.

**Tools used:** Azure Cloud Shell (Bash / Azure CLI)

### Steps

1. **Created the resource group**
   ![Resource group creation](screenshots/01-resource-group.png)
   Commit: [fdc3ea7](https://github.com/salokieran1-cell/Portfolio-Project/commit/fdc3ea70708c70d994fdfdfdf969bd1e696b9a2b)

2. **Created the virtual machine**
   ![VM creation output](screenshots/02-vm-created.png)
   Commit: [aa79b81](https://github.com/salokieran1-cell/Portfolio-Project/commit/aa79b81b547c8c9294e8e9697aa559125fd4e398)

   Azure flagged that this VM wasn't created with Trusted Launch (secure boot + vTPM) enabled. For this learning project I used the default configuration, but in a production scenario I'd enable Trusted Launch at creation time — `--security-type TrustedLaunch` — to protect against boot-level threats like rootkits.

3. **Configured the Network Security Group**
   ![NSG rules](screenshots/03-nsg-rules.png)
   Commit: [f42f6d8](https://github.com/salokieran1-cell/Portfolio-Project/commit/f42f6d804365c81504b7250cbbe9cbcd6594a3c1)

   Configured the NSG for least-privilege inbound access:
   - Deny-all baseline rule (priority 4096)
   - SSH allow scoped to my IP only (priority 100)
   - Attached the NSG directly to the VM's network interface

### Notes / Troubleshooting

- **Local PowerShell/Az module bug**: hit a `WriteObject`/`WriteError` threading error using the `New-AzVm` cmdlet, both locally and initially in Cloud Shell's PowerShell mode. This turned out to be a documented issue in the cmdlet itself, not an environment problem — adjusting `$ProgressPreference` and reinstalling the Az module didn't resolve it. Switched to Azure CLI (Bash) in Cloud Shell instead, which uses a different code path and isn't affected by the bug.
- **`SkuNotAvailable` error**: `Standard_B1s` wasn't available in the `southafricanorth` region at the time of deployment (a capacity constraint on Azure's side, not a config issue). Resolved by switching to `Standard_B2ats_v2`, another free-tier-eligible burstable size.
- **`MissingSubscriptionRegistration` error**: new subscription hadn't yet registered the `Microsoft.Compute` resource provider — a one-time step required before first use. Resolved with `az provider register --namespace Microsoft.Compute`.

---

## Project 2: Conditional Access

**Goal:** Configure a Conditional Access policy to control sign-in requirements.

**Tools used:** Azure Portal

### Steps

1. **Set up the Conditional Access policy**
   ![Conditional access policy](screenshots/04-conditional-access.png)
   Commit: [link to commit]

### Notes / Troubleshooting

_(fill in as you go)_

---

## Certifications (in progress)

- Microsoft Certified: Azure Fundamentals (AZ-900)
- Microsoft Certified: Azure Administrator Associate (AZ-104)
- Microsoft Certified: Azure Security Engineer Associate (AZ-500)
- Microsoft Certified: Cybersecurity Architect Expert (SC-100)
- Microsoft Certified: Security Operations Analyst Associate (SC-200)

## Contact

_(add your LinkedIn / email if you want recruiters to reach out directly)_


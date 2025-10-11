# OpenTofu Infrastructure

This directory contains OpenTofu (Terraform) configurations to manage external services for the Koko home server infrastructure.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Cloudflare Configuration](#cloudflare-configuration)
- [OVH Configuration](#ovh-configuration)
- [Deployment](#deployment)
- [Resources Created](#resources-created)

## Prerequisites

1. **Install OpenTofu**
   - Follow the installation guide at: https://opentofu.org/docs/intro/install/
   - Or use the Terraform-compatible binary from: https://www.terraform.io/downloads.html

2. **Create Required Directories**
   ```bash
   sudo mkdir -p /bkp/tofu/cloudflare
   sudo mkdir -p /bkp/tofu/ovh
   sudo chown -R $USER:$USER /bkp/tofu
   ```

## Directory Structure

```
tofu/
├── cloudflare/          # Cloudflare DNS and R2 bucket configuration
│   ├── provider.tf      # Provider and backend configuration
│   ├── variables.tf     # Variable definitions
│   ├── dns.tf          # DNS zone and records
│   ├── buckets.tf      # R2 bucket configuration
│   └── outputs.tf      # Output values
└── ovh/                # OVH domain registration
    ├── provider.tf     # Provider and backend configuration
    ├── variables.tf    # Variable definitions
    └── domain.tf       # Domain name configuration
```

## Cloudflare Configuration

### Step 1: Create Cloudflare API Token

You need to create an API token with appropriate permissions:

1. Go to: **https://dash.cloudflare.com/?to=/:account/r2/api-tokens**
2. Click on "Create Token"
3. Use "Edit zone DNS" template or create a custom token with these permissions:
   - **Zone - DNS - Edit**
   - **Zone - Zone - Read**
   - **Account - Account Settings - Read**
   - **Account - R2 - Edit** (for R2 bucket management)
4. For "Zone Resources", select:
   - Include - Specific zone - Select your domain
5. Copy the generated API token (you won't be able to see it again!)

### Step 2: Get Your Account ID

1. Log in to Cloudflare Dashboard
2. Select your domain
3. On the right side, under "API", you'll see your **Account ID**
4. Copy this value

### Step 3: Create terraform.tfvars File

Create the file `/bkp/tofu/cloudflare/terraform.tfvars` with your values:

```hcl
cloudflare_account_id = "your-account-id-here"
cloudflare_email      = "your-email@example.com"
cloudflare_api_token  = "your-api-token-here"
zone_name             = "yourdomain.com"
koko_ip               = "192.168.0.39"  # Or your server's IP
```

**Important:** Never commit this file to version control as it contains sensitive credentials!

### What It Creates

The Cloudflare configuration creates:
- **DNS Zone**: Managed zone for your domain
- **DNS Records**:
  - `A` record for main domain → `192.168.0.39`
  - `A` record for wildcard `*` → `192.168.0.39`
  - `CNAME` record for `www` → main domain
- **R2 Bucket**: `tf-bucket` in the `eeur` (Eastern Europe) location

## OVH Configuration

OVH is used to register the domain and point it to Cloudflare nameservers.

### Step 1: Create OVH API Credentials

1. Go to: https://eu.api.ovh.com/createToken/
2. Fill in:
   - **Application name**: e.g., "Koko Tofu"
   - **Application description**: e.g., "OpenTofu domain management"
   - **Validity**: Unlimited or as needed
3. Set rights:
   - `GET /domain/*`
   - `PUT /domain/*`
   - `POST /domain/*`
   - `DELETE /domain/*`
4. Click "Create keys"
5. Save the:
   - Application Key
   - Application Secret
   - Consumer Key

### Step 2: Export OVH Credentials

```bash
export OVH_APPLICATION_KEY="your-application-key"
export OVH_APPLICATION_SECRET="your-application-secret"
export OVH_CONSUMER_KEY="your-consumer-key"
```

### Step 3: Create terraform.tfvars File

Create the file `/bkp/tofu/ovh/terraform.tfvars` with your values:

```hcl
domain_name = "yourdomain.com"
```

**Note:** OVH credentials are provided via environment variables, not in the tfvars file.

### What It Creates

The OVH configuration:
- Registers/manages your domain name
- Automatically configures DNS to use Cloudflare nameservers (from Cloudflare state)

## Deployment

### Deploy Cloudflare Infrastructure (First)

```bash
cd tofu/cloudflare
tofu init
tofu plan -var-file=/bkp/tofu/cloudflare/terraform.tfvars
tofu apply -var-file=/bkp/tofu/cloudflare/terraform.tfvars
```

**Note:** Run Cloudflare first as OVH depends on its outputs (nameservers).

### Deploy OVH Infrastructure (Second)

```bash
cd tofu/ovh
export OVH_APPLICATION_KEY="your-key"
export OVH_APPLICATION_SECRET="your-secret"
export OVH_CONSUMER_KEY="your-consumer-key"
tofu init
tofu plan -var-file=/bkp/tofu/ovh/terraform.tfvars
tofu apply -var-file=/bkp/tofu/ovh/terraform.tfvars
```

### Verify Deployment

After deployment:
1. Check Cloudflare Dashboard to verify DNS records
2. Wait for DNS propagation (can take up to 24-48 hours)
3. Verify with: `dig yourdomain.com` or `nslookup yourdomain.com`

## Resources Created

### Cloudflare Resources
- 1 DNS Zone
- 3 DNS Records (main domain, wildcard, www)
- 1 R2 Bucket (Standard storage, Eastern Europe)

### OVH Resources
- 1 Domain name with Cloudflare nameservers

## State Management

- Cloudflare state: `/bkp/tofu/cloudflare/terraform.tfstate`
- OVH state: `/bkp/tofu/ovh/terraform.tfstate`

Both configurations use local backend for state storage. Make sure to backup these files!

## Troubleshooting

### "Error: Invalid credentials"
- Verify your API tokens are correct
- Check that tokens haven't expired
- Ensure proper permissions are set on the tokens

### "Error: Zone already exists"
- If the zone already exists in Cloudflare, import it first:
  ```bash
  tofu import cloudflare_zone.wyppu <zone-id>
  ```

### "Error: Backend configuration"
- Ensure `/bkp/tofu/` directories exist and have proper permissions
- The backend path must be absolute

## Security Notes

- **Never commit** `terraform.tfvars` files to version control
- Store API tokens and credentials securely
- Rotate credentials periodically
- Use least-privilege principle when creating API tokens
- Backup state files regularly

## Additional Resources

- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Cloudflare Provider Documentation](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)
- [OVH Provider Documentation](https://registry.terraform.io/providers/ovh/ovh/latest/docs)
- [Cloudflare R2 Documentation](https://developers.cloudflare.com/r2/)

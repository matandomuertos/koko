# Terraform Configurations for Cloudflare and OVH

This directory contains Terraform (or OpenTofu) configurations to manage DNS records on Cloudflare and domain names on OVH.

## Table of Contents

1.  [Introduction](#introduction)
2.  [Prerequisites](#prerequisites)
3.  [Setup](#setup)
    *   [Cloudflare Configuration](#cloudflare-configuration)
    *   [OVH Configuration](#ovh-configuration)
4.  [Deployment](#deployment)
    *   [Cloudflare Deployment](#cloudflare-deployment)
    *   [OVH Deployment](#ovh-deployment)
5.  [Managed Resources](#managed-resources)

## Introduction

These configurations allow you to automate the management of:
*   **Cloudflare:** R2 buckets and DNS records for a specified zone.
*   **OVH:** Domain name registration, linking it to Cloudflare's name servers.

The Terraform state is managed using an S3-compatible backend, specifically Cloudflare R2.

## Prerequisites

Before you begin, ensure you have the following:

*   **OpenTofu or Terraform CLI:** Installed on your system.
*   **Cloudflare Account:** With an Account ID, API Token, and the email associated with your account.
*   **OVH Account:** With Application Key, Application Secret, and Consumer Key.
*   **Cloudflare R2 Bucket:** An existing R2 bucket to store Terraform state, along with its Access Key and Secret Key.

## Setup

### Cloudflare Configuration

1.  Navigate to the Cloudflare configuration directory:
    ```bash
    cd tofu/cloudflare
    ```
2.  Create a `terraform.tfvars` file in this directory to provide your sensitive Cloudflare credentials and other variables. Replace the placeholder values with your actual information:
    ```hcl
    cloudflare_account_id = "your_cloudflare_account_id"
    cloudflare_email      = "your_cloudflare_email"
    cloudflare_api_token  = "your_cloudflare_api_token"
    zone_name             = "your_domain.com"
    koko_ip               = "your_koko_service_ip" # Optional, defaults to "192.168.0.39"
    ```

### OVH Configuration

1.  Navigate to the OVH configuration directory:
    ```bash
    cd tofu/ovh
    ```
2.  Create a `terraform.tfvars` file in this directory to provide your sensitive OVH and Cloudflare R2 credentials. Replace the placeholder values with your actual information:
    ```hcl
    application_key       = "your_ovh_application_key"
    application_secret    = "your_ovh_application_secret"
    consumer_key          = "your_ovh_consumer_key"
    domain_name           = "your_domain.com"
    cloudflare_account_id = "your_cloudflare_account_id"
    cloudflare_r2_bucket  = "your_r2_bucket_name"
    cloudflare_r2_access_key = "your_r2_access_key"
    cloudflare_r2_secret_key = "your_r2_secret_key"
    ```

## Deployment

The deployment involves two main steps: first for Cloudflare resources, then for OVH resources.

### Cloudflare Deployment

1.  Ensure you are in the `tofu/cloudflare` directory:
    ```bash
    cd tofu/cloudflare
    ```
2.  Initialize Terraform/OpenTofu, configuring the S3 backend. You will need a `backend.hcl` file at `/bkp/tofu/backend.hcl` or adjust the command to point to your backend configuration.
    ```bash
    opentofu init -backend-config=/bkp/tofu/backend.hcl
    ```
    *Note: The `backend.hcl` file should contain S3 backend configuration details if not already defined in `provider.tf`.* 
3.  Review the planned changes:
    ```bash
    opentofu plan -var-file=terraform.tfvars
    ```
4.  Apply the changes to create/update Cloudflare resources:
    ```bash
    opentofu apply -var-file=terraform.tfvars
    ```

### OVH Deployment

1.  Ensure you are in the `tofu/ovh` directory:
    ```bash
    cd tofu/ovh
    ```
2.  Initialize Terraform/OpenTofu, configuring the S3 backend.
    ```bash
    opentofu init -backend-config=/bkp/tofu/backend.hcl
    ```
3.  Review the planned changes:
    ```bash
    opentofu plan -var-file=terraform.tfvars
    ```
4.  Apply the changes to create/update OVH resources:
    ```bash
    opentofu apply -var-file=terraform.tfvars
    ```

## Managed Resources

*   **`cloudflare/buckets.tf`**: Manages a Cloudflare R2 bucket.
*   **`cloudflare/dns.tf`**: Configures A and CNAME DNS records within your Cloudflare zone.
*   **`cloudflare/outputs.tf`**: Exports the Cloudflare name servers, which are then used by the OVH configuration.
*   **`cloudflare/provider.tf`**: Sets up the Cloudflare provider and configures the S3 backend for state management.
*   **`cloudflare/variables.tf`**: Defines input variables for the Cloudflare configuration.
*   **`ovh/domain.tf`**: Manages the OVH domain name, setting its name servers to those provided by Cloudflare.
*   **`ovh/provider.tf`**: Sets up the OVH provider and configures the S3 backend for state management.
*   **`ovh/variables.tf`**: Defines input variables for the OVH configuration, including Cloudflare R2 details for remote state access.

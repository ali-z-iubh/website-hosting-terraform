# Static Website Hosting - Configuration

This project provisions services from Amazon Web Services (AWS) to host a static website. It uses Amazon S3 for storing the files of the site and Amazon CloudFront as Content Delivery Network (CDN) for improved global performance and security.

---

## Project Structure

#### Terraform Configuration file:
main.tf

#### Main homepage file:
index.html

#### Custom error page file:
error.html

---

## Services

- **Amazon S3 Bucket**
    - Hosts the static website files
    - Configured with website hosting settings and public read access.

- **CloudFront Distribution**
    - Distributes the website globally with low latency.

- **Terraform Outputs**
    - Displays both the S3 website endpoint and CloudFront distribution domain after deployment.

## Resources Created

| AWS Service | Resource | Description |
|--------------|-----------|-------------|
| **S3** | `aws_s3_bucket.website` | Hosts the website content |
| **S3** | `aws_s3_bucket_website_configuration.website_config` | Defines index and error pages |
| **S3** | `aws_s3_bucket_policy.bucket_policy` | Allows public read access to website files |
| **S3** | `aws_s3_bucket_public_access_block.public_access` | Configures bucket to allow public access |
| **S3** | `aws_s3_object.index`, `aws_s3_object.error` | Uploads the HTML files to the bucket |
| **CloudFront** | `aws_cloudfront_distribution.cdn` | Speeds up content delivery through CDN |

---

## How to Use

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Review the Execution Plan
```bash
terraform plan
```

### 3. Apply the Configuration
```bash
terraform apply
```
Type 'yes' when prompted to configure the resources creation.

### 4. View Output
After applying, Terraform will output:
- The S3 website URL
- THe CloudFront distribution URL

# To remove resources
If for some reason you want to destroy all the built resources, you can do it through this command:
```bash
terraform destroy
```

# AWS Region
All resources are created in the following region:
```
eu-north-1
```
---

# Author
**Alishba Zehra**

Cloud Programming Project

11 October, 2025

#### Note: 
This project is a university course assignment, for the course *DLBSEPCP01_E*.

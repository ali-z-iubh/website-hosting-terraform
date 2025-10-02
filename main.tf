#Specifies the AWS provider and the region to use
provider "aws" {
    region = "eu-north-1"
}

# --- S3 Resources start ---

# Creates an S3 bucket named aliz-terraform-website
resource "aws_s3_bucket" "website" {
    bucket = "aliz-terraform-website" 
}

# Configures site hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.bucket
  #Tells S3 to use index.html as homepage
  index_document {
    suffix = "index.html"
  }
  #Tells S3 to use error.html as error page
  error_document {
    key = "error.html"
  }
}


# Bucket policy for public read access
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website.id

  depends_on = [ aws_s3_bucket_public_access_block.public_access ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# Allows public access on the bucket (disable block public access settings)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false  
}


#Upload index.html to S3 bucket
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website.bucket
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}

#Upload error.html to S3 bucket
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.website.bucket
  key    = "error.html"
  source = "error.html"
  content_type = "text/html"
}

# Outputs the website URL to you when you run 'terraform apply'
output "website_url" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

# --- S3 Resources end ---

# --- CloudFront Resources start ---

# Cloudfront distribution for static website
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = "aliz-terraform-website.s3-website.eu-north-1.amazonaws.com"
    origin_id   = "s3-website-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "s3-website-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [ "GET", "HEAD" ]
    cached_methods  = [ "GET", "HEAD" ]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100" 

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

#Outputs CloudFront URL
output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn.domain_name
}
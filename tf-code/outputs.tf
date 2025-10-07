# Output the website URL
output "website_url" {
  value = aws_s3_bucket_website_configuration.website-config.website_endpoint
  description = "The URL for the static website."
}
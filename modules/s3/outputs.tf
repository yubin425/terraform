output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.frontend.id
}
output "website_url" {
  value = aws_s3_bucket_website_configuration.frontend.website_endpoint
}
output "bucket_arn" {
  value = aws_s3_bucket.frontend.arn
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.frontend.bucket_regional_domain_name
}

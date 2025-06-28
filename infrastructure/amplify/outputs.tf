output "default_domain" {
  description = "The default domain link to access the web page"
  value       = aws_amplify_app.notesapp.default_domain
}
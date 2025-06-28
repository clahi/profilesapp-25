variable "access_token" {
  description = "The personal token of the github repo which has a write access to the repo."
  sensitive   = true
  type        = string
}
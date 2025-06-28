terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }
  required_version = ">= 1.7"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_amplify_app" "notesapp" {
  name       = "profilesapp"
  repository = "https://github.com/clahi/profilesapp-25"

  # The default build_spec added by the Amplify Console React.
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - cd profilesapp
            - nvm use 20
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: profilesapp/dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # GitHub personal access token
  access_token = var.access_token

  enable_auto_branch_creation = true

  # The default patterns added by the Amplify Console.
  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]

  auto_branch_creation_config {
    # Enable auto build for the created branch.
    enable_auto_build = true
  }

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.notesapp.id
  branch_name = "main"

  enable_auto_build = true

  stage = "PRODUCTION"

  environment_variables = {
    "ENV" = "production"
  }
}
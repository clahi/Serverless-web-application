resource "aws_amplify_app" "my-amplify-app" {
  name         = "wildrydes-app"
  repository   = "https://github.com/clahi/Serverless-web-application"
  access_token = var.access-token

  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - cd front-end-code
            - yarn install
        build:
          commands:
            - echo "No build step needed"
      artifacts:
        baseDirectory: front-end-code
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # Auto Branch Creattion
  enable_auto_branch_creation = true

  enable_branch_auto_build = true

  auto_branch_creation_config {
    # Enable auto build for the created branch.
    enable_auto_build = true
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.my-amplify-app.id
  branch_name = "main"

  enable_auto_build = true

  stage = "PRODUCTION"

  environment_variables = {
    "ENV" = "production"
  }
}
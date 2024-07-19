# Create and verify an ses email in order to send automatic emails to users on sign up using this ses email.
resource "aws_ses_email_identity" "ses_email" {
  email = "abdalamoha2022@gmail.com"
}

# Creating a cognit user pool
resource "aws_cognito_user_pool" "WildRydes" {
  name = "WildRydes"

  auto_verified_attributes = ["email"]

  # Configuration on how to send email to the signed up user
  email_configuration {
    source_arn            = aws_ses_email_identity.ses_email.arn
    email_sending_account = "DEVELOPER"
    from_email_address    = "abdalamoha2022@gmail.com"
  }
}

# Create a user pool client app that will be connected to our web app.
resource "aws_cognito_user_pool_client" "WildRydesWebApp" {
  name         = "WildRydesWebApp"
  user_pool_id = aws_cognito_user_pool.WildRydes.id
}
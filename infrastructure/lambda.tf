resource "aws_iam_role" "WildRydesLambda" {
  name = "WildRydesLambda"

  assume_role_policy = jsonencode({

    "Version" : "2012-10-17",
    "Statement" : [

      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com"
          ]
        }
      }
    ]

  })

  inline_policy {
    name = "DynamoDBWriteAccess"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "dynamodb:PutItem",
          "Resource" : aws_dynamodb_table.Rides.arn
        }
      ]
    })


  }

}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.js"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "RequestUnicorn" {
  function_name = "RequestUnicorn"
  role          = aws_iam_role.WildRydesLambda.arn

  filename         = "lambda_function_payload.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "nodejs16.x"
  handler          = "lambda.handler"
}
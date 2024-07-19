# A dynamodb table to store the requests made by the customers.
# The request is stored to the dynamodb table through the lambda function
resource "aws_dynamodb_table" "Rides" {
  name           = "Rides"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "RideId"

  attribute {
    name = "RideId"
    type = "S"
  }
}
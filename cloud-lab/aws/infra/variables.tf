variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to use for state locking."
  default     = "tf-remote-state-lock"
}

variable "dynamodb_table_billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  default     = "PAY_PER_REQUEST"
}


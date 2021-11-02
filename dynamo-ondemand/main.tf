resource "aws_dynamodb_table" "tf-state-lock" {
  name = "${var.env_type}-${var.table_name}"
  hash_key = var.hash_key
  billing_mode = "PAY_PER_REQUEST"
  dynamic "attribute" {
    for_each = var.table_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = merge(var.common_tags)
}

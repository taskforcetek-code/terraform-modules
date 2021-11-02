##################################################################################################
#Terraform State Bucket
##################################################################################################

provider "aws" {
  alias  = "state"
  region = var.aws_region_main
}
provider "aws" {
  alias = "backup"
  region = var.aws_region_backup
}

resource "aws_kms_key" "bucket-key" {
 description             = "This key is used to encrypt bucket objects"
 deletion_window_in_days = 10
}

resource "aws_iam_role" "replication" {
  name = "${var.env_type}-tf-iam-role-rep"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
tags = merge(var.common_tags)
}

resource "aws_iam_policy" "replication" {
  name = "tf-iam-role-policy-rep"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.state.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.state.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.backup.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  name       = "${var.env_type}-tf-iam-role-att-rep"
  roles      = [aws_iam_role.replication.name]
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket" "state" {
  provider = aws.state
  bucket   = "${var.env_type}-${var.bucket_name}"
  acl      = "private"
  versioning {
    enabled = true
  }

 server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
       kms_master_key_id = aws_kms_key.bucket-key.arn
       sse_algorithm     = "aws:kms"
     }
   }
 }

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "StateReplicationAll"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.backup.arn
        storage_class = "STANDARD"
        replica_kms_key_id = aws_kms_key.bucket-key.arn
      }
      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }

    }
  }
  tags = merge(var.common_tags)
}


resource "aws_s3_bucket" "backup" {
  provider = aws.backup
  bucket = "${var.env_type}-${var.bucket_name}-replicated"
  versioning {
    enabled = true
  }
 server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
       kms_master_key_id = aws_kms_key.bucket-key.arn
       sse_algorithm     = "aws:kms"
     }
   }
 }
  tags = merge(var.common_tags)
}
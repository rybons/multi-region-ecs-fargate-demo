resource "aws_ecr_repository" "ecr" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_user_policy" "ecr_ci_iam_policy" {
  name        = "${var.name}-ci-iam-policy"

  user   = aws_iam_user.ecr_ci_iam_user.name
  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"AllowPush",
         "Effect":"Allow",
         "Action":[
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload"
         ],
         "Resource":"${aws_ecr_repository.ecr.arn}"
      },
      {
         "Sid":"GetAuthorizationToken",
         "Effect":"Allow",
         "Action":[
            "ecr:GetAuthorizationToken"
         ],
         "Resource":"*"
      }
   ]
}
EOF
}

resource "aws_iam_user" "ecr_ci_iam_user" {
  name = "${var.name}-ecr-iam-user"
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_access_key" "ecr_ci_iam_user_credentials" {
  user = aws_iam_user.ecr_ci_iam_user.name
}
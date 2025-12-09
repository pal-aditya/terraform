resource "aws_s3_bucket" "Just_an_demo" {
    bucket_name = "clitoris_restart"
    bucket_prefix = "shanon"
    force_destroy = true
    object_lock_enabled = true

    tags = {
        name = "Just_an_demo"
    }
}

resource "aws_s3_object" "labia"{
    bucket = aws_s3_bucket.Just_an_demo.bucket_name
    key = "demo.webp"
    source = "/home/aditya/Downloads/demo.webp"
    etag = filemd5("/home/aditya/Downloads/demo.webp")
}
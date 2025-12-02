resource "aws_dynamodb_table" "dec_restart"{
    name = "student"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "student_id"

#Attributes should be defined for only the key's we've used like in hash key,sort key and LSI,GSI

    attribute {
        name = "student_id"
        type = "N"
    }

#ttl (attribute_name - (Optional) Name of the table attribute to store the TTL timestamp in. Required if enabled is true, must not be set otherwise.)

    ttl {
        attribute_name = "ttl"
        enabled = true
    }   
    point_in_time_recovery{
        enabled = true
    }

    server_side_encryption {
        enabled = true
        kms_key_arn = "arn:aws:kms:ap-south-1:676290432212:key/e6cc1d38-2c6a-40b7-922b-cfaeab982bbc"
    }

# Two Options for table class:- Standard(Default),DynamoDB STandard Infrequent Access [Where the storage cost is dominant and we don't required data frequently]

    table_class = "STANDARD"

    tags = {
        name = "DynamoDBexample"
    }
}
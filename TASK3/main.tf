# aws user credentials: should be hidden
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

###################################################################################################
### VPC
###################################################################################################
resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "Pavlo VPC"
 }
}

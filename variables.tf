provider "aws" {
  region     = "us-east-1"
  access_key = "ASIA4FZE7EDOPU5IEWNR"
  secret_key = "MFSQzwTVUywobMNz8uucadFyYBNcIPC+zCf96aKq"
  token = "AgoJb3JpZ2luX2VjEDcaCXVzLWVhc3QtMSJIMEYCIQCKxzgxdU9QMHL41+3TAodIehjPYi7xM98ZQYWeB1iKXQIhAK/nsEEB88prSq+eXWixgUlrrowdksMBTjDbdZBrRJmVKswCCPD//////////wEQABoMODM3MDU5Mjg5MzA4Igyq0X0w6Xv8l5G4p7EqoALYfGrVUtYAxH7L8Al71y1aWh/e6ky6QXrUVrJQepiR86UA8CA2mMVuYgHng0OchKkeSCRv/h7Osu3vrbFRRag3cQEFTMhbpvneP7pwxUks86f9XonQ+snMJQJ2Z2OxJFbQP9lhKGGWtoE17VgP+NpiBiLmJX0b7czVwVv9V9PBni3twHObXMqek+NaFsUMzsKZWJHaMzBZRXsRYT9sqffVYyApRpLs4y3ztEqHimhTHeV1izDUg/ay0IBgMazo77hiZK4RsQrhH9IdFX2Xwk8vybCNVIUOupJH9xu0J0QI/+X3HJi1+QW4LmSCYHeNVcSLu/uLmCAq+AZY9Lsy7VpWEeG6fLP3UIBMccNBxeykvU2q0VikBPHeW048zx0iUxcw+K3p6wU6swGR7QPV8+kwwvDaCJh4fTjuUog6Y86mF2K6RXf4px+KVC7iicE7pl14ht5Uw5lrG2daWng/SjG6TDQs2Mo749CdPLcKnbW8UpurxoJYTWHIbo+E+L5DriPDjeDPnrLxCSIqWh4FtEdYcvUmpo1iZcNjgZsyClVL3b+dDvaAUGhvWaSDeO33bkQHGBVUNGON2FzIcsoZCGobh6n9c3PlW0MYZZmDEhutiF8I2bwfqvuXyDcQKg=="
}

variable "aws_region" {
  default = "us-east-1"
}

# use data to pull in existing vpc by tag
data "aws_vpc" "shared-vpc" {
  tags = { Environment = "shared-services" }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.shared-vpc.id
  tags = { Network = "Public" }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.shared-vpc.id
  tags = { Network = "Private" }
}

output "vpc" {
  value = data.aws_vpc.shared-vpc.id
}

output "public" {
  value = data.aws_subnet_ids.public.ids
}

output "private" {
  value = data.aws_subnet_ids.private.ids
}
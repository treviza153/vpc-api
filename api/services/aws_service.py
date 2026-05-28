import logging

import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)


class AWSService:
    def __init__(self):
        self.ec2 = boto3.client("ec2")

    def create_vpc(self, vpc_name: str, cidr_block: str, subnets: dict = None) -> dict:
        """Creates a VPC and optionally its subnets in AWS."""
        try:
            response = self.ec2.create_vpc(
                CidrBlock=cidr_block,
                TagSpecifications=[
                    {
                        "ResourceType": "vpc",
                        "Tags": [{"Key": "Name", "Value": vpc_name}],
                    }
                ],
            )
        except ClientError as exc:
            logger.error("EC2 create_vpc failed: %s", exc.response["Error"]["Message"])
            raise

        vpc_id = response["Vpc"]["VpcId"]
        logger.info("Created VPC %s (%s)", vpc_name, vpc_id)

        # Enable DNS support and hostnames
        self.ec2.modify_vpc_attribute(VpcId=vpc_id, EnableDnsSupport={"Value": True})
        self.ec2.modify_vpc_attribute(VpcId=vpc_id, EnableDnsHostnames={"Value": True})

        created_subnets = {}
        if subnets:
            created_subnets = self.create_subnets(vpc_id=vpc_id, subnets=subnets)

        return {
            "vpc_id": vpc_id,
            "cidr_block": cidr_block,
            "created_subnets": created_subnets,
        }

    def create_subnets(self, vpc_id: str, subnets: dict) -> dict:
        """Creates subnets inside an existing VPC. Expects {subnet_name: cidr_block}."""
        created = {}

        for subnet_name, cidr in subnets.items():
            try:
                response = self.ec2.create_subnet(
                    VpcId=vpc_id,
                    CidrBlock=cidr,
                    TagSpecifications=[
                        {
                            "ResourceType": "subnet",
                            "Tags": [{"Key": "Name", "Value": subnet_name}],
                        }
                    ],
                )
                subnet_id = response["Subnet"]["SubnetId"]
                created[subnet_name] = {
                    "subnet_id": subnet_id,
                    "cidr_block": cidr,
                    "vpc_id": vpc_id,
                }
                logger.info("Created subnet %s (%s) in VPC %s", subnet_name, subnet_id, vpc_id)
                
            except ClientError as exc:
                logger.error("EC2 create_subnet failed for %s: %s", subnet_name, exc.response["Error"]["Message"])
                raise

        return created

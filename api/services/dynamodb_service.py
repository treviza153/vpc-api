import logging
import os

import boto3
from boto3.dynamodb.conditions import Attr
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

VPC_TABLE = os.environ.get("VPC_TABLE", "infra-api-vpcs")
NETWORK_TABLE = os.environ.get("NETWORK_TABLE", "infra-api-networks")


class DynamoDBService:
    def __init__(self):
        self.dynamodb = boto3.resource("dynamodb")
        self.vpc_table = self.dynamodb.Table(VPC_TABLE)
        self.network_table = self.dynamodb.Table(NETWORK_TABLE)

    def put_vpc(self, item: dict) -> None:
        try:
            self.vpc_table.put_item(Item=item)
            logger.info("Stored VPC %s in DynamoDB", item.get("id"))
            
        except ClientError as exc:
            logger.error("DynamoDB put_vpc failed: %s", exc.response["Error"]["Message"])
            raise

    def list_vpcs(self) -> list:
        try:
            items = []
            response = self.vpc_table.scan()
            items.extend(response.get("Items", []))

            # Handle pagination for large datasets
            while "LastEvaluatedKey" in response:
                response = self.vpc_table.scan(
                    ExclusiveStartKey=response["LastEvaluatedKey"]
                )
                items.extend(response.get("Items", []))

            return items

        except ClientError as exc:
            logger.error("DynamoDB list_vpcs failed: %s", exc.response["Error"]["Message"])
            raise

    def put_network(self, item: dict) -> None:
        try:
            self.network_table.put_item(Item=item)
            logger.info("Stored network %s in DynamoDB", item.get("id"))

        except ClientError as exc:
            logger.error("DynamoDB put_network failed: %s", exc.response["Error"]["Message"])
            raise

    def list_networks(self) -> list:
        try:
            items = []
            response = self.network_table.scan()
            items.extend(response.get("Items", []))

            # Handle pagination for large datasets
            while "LastEvaluatedKey" in response:
                response = self.network_table.scan(
                    ExclusiveStartKey=response["LastEvaluatedKey"]
                )
                items.extend(response.get("Items", []))

            return items
            
        except ClientError as exc:
            logger.error("DynamoDB list_networks failed: %s", exc.response["Error"]["Message"])
            raise

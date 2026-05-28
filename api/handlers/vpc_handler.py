import json
import logging
from datetime import datetime, timezone

from services.aws_service import AWSService
from services.dynamodb_service import DynamoDBService

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def build_response(status_code: int, body: dict) -> dict:
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        "body": json.dumps(body, default=str),
    }


class VpcHandler:
    def __init__(self):
        self.aws_service = AWSService()
        self.dynamodb_service = DynamoDBService()

    def create_vpc(self, body: dict) -> dict:
        vpc_name = body.get("vpc_name")
        network = body.get("network")

        if not vpc_name:
            return build_response(400, {"error": "vpc_name is mandatory"})
            
        if not network:
            return build_response(400, {"error": "network is mandatory"})

        subnets = body.get("subnets", {})

        try:
            vpc_result = self.aws_service.create_vpc(
                vpc_name=vpc_name,
                cidr_block=network,
                subnets=subnets,
            )

            item = {
                "id": vpc_result["vpc_id"],
                "vpc_name": vpc_name,
                "network": network,
                "subnets": subnets,
                "aws_vpc_id": vpc_result["vpc_id"],
                "created_subnets": vpc_result.get("created_subnets", {}),
                "created_at": datetime.now(timezone.utc).isoformat(),
            }

            self.dynamodb_service.put_vpc(item)
            logger.info("VPC %s created and stored in DynamoDB!", vpc_result["vpc_id"])

            return build_response(201, {
                "message": "VPC created successfully",
                "vpc": item,
            })

        except Exception as exc:
            logger.error("Error creating VPC: %s", str(exc))
            return build_response(500, {"error": f"Failed to create VPC: {str(exc)}"})

    def list_vpcs(self) -> dict:
        try:
            vpcs = self.dynamodb_service.list_vpcs()
            return build_response(200, {"vpcs": vpcs, "count": len(vpcs)})

        except Exception as exc:
            logger.error("Error listing VPCs: %s", str(exc))
            return build_response(500, {"error": f"Failed to list VPCs: {str(exc)}"})

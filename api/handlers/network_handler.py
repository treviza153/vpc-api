import json
import logging
import uuid
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


class NetworkHandler:
    def __init__(self):
        self.aws_service = AWSService()
        self.dynamodb_service = DynamoDBService()

    def create_network(self, body: dict) -> dict:
        network = body.get("network")

        if not network:
            return build_response(400, {"error": "network is mandatory"})

        subnets = body.get("subnets", {})
        vpc_id = body.get("vpc_id")

        try:
            network_id = str(uuid.uuid4())
            created_subnets = {}

            if vpc_id and subnets:
                created_subnets = self.aws_service.create_subnets(
                    vpc_id=vpc_id,
                    subnets=subnets,
                )

            item = {
                "id": network_id,
                "network": network,
                "subnets": subnets,
                "vpc_id": vpc_id or "standalone",
                "created_subnets": created_subnets,
                "created_at": datetime.now(timezone.utc).isoformat(),
            }

            self.dynamodb_service.put_network(item)
            logger.info("Network %s stored in DynamoDB!", network_id)

            return build_response(201, {
                "message": "Network created successfully!",
                "network": item,
            })

        except Exception as exc:
            logger.error("Error creating network: %s", str(exc))
            return build_response(500, {"error": f"Failed to create network: {str(exc)}"})

    def list_networks(self) -> dict:
        try:
            networks = self.dynamodb_service.list_networks()
            return build_response(200, {"networks": networks, "count": len(networks)})
            
        except Exception as exc:
            logger.error("Error listing networks: %s", str(exc))
            return build_response(500, {"error": f"Failed to list networks: {str(exc)}"})

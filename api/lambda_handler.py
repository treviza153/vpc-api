import json
import logging

from handlers.vpc_handler import VpcHandler
from handlers.network_handler import NetworkHandler

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def build_response(status_code: int, body: dict) -> dict:
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        "body": json.dumps(body),
    }


def lambda_handler(event, context):
    logger.info("Event: %s", json.dumps(event))

    # HTTP API (v2) event format
    http_method = event.get("requestContext", {}).get("http", {}).get("method", "")
    raw_path = event.get("rawPath", "")

    # Normalize path
    path = raw_path.rstrip("/").lower()

    try:
        body = {}
        if event.get("body"):
            body = json.loads(event["body"])
            
    except (json.JSONDecodeError, TypeError):
        return build_response(400, {"error": "Invalid JSON body"})

    vpc_handler = VpcHandler()
    network_handler = NetworkHandler()

    if path == "/vpc":
        if http_method == "POST":
            return vpc_handler.create_vpc(body)
        elif http_method == "GET":
            return vpc_handler.list_vpcs()
        else:
            return build_response(405, {"error": "Method not allowed"})

    elif path == "/network":
        if http_method == "POST":
            return network_handler.create_network(body)
        elif http_method == "GET":
            return network_handler.list_networks()
        else:
            return build_response(405, {"error": "Method not allowed"})

    else:
        return build_response(404, {"error": f"Path '{raw_path}' not found"})

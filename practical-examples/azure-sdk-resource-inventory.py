"""Read-only Azure resource inventory without MCP.

Prerequisites:
  pip install azure-identity azure-mgmt-resource
  az login --tenant <tenant-id> --use-device-code
"""

from azure.identity import AzureCliCredential
from azure.mgmt.resource import ResourceManagementClient


SUBSCRIPTION_ID = "292e62e6-54a8-4c6a-b996-0c83f8cc29d0"


def main() -> None:
    credential = AzureCliCredential()
    client = ResourceManagementClient(credential, SUBSCRIPTION_ID)

    for resource_group in client.resource_groups.list():
        print(f"RESOURCE_GROUP\t{resource_group.name}\t{resource_group.location}")
        for resource in client.resources.list_by_resource_group(resource_group.name):
            print(f"RESOURCE\t{resource_group.name}\t{resource.name}\t{resource.type}\t{resource.location}")


if __name__ == "__main__":
    main()

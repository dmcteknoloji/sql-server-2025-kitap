# ============================================================================
# 04-event-hubs-tuketici.py
# ----------------------------------------------------------------------------
# CES'ten gelen CloudEvents'leri Event Hubs üstünden tüket.
# pip install azure-eventhub azure-identity
# ============================================================================

import asyncio
import json
from azure.eventhub.aio import EventHubConsumerClient
from azure.identity.aio import DefaultAzureCredential

EVENT_HUB_NAMESPACE = "your-eh-namespace.servicebus.windows.net"
EVENT_HUB_NAME = "orders-events"
CONSUMER_GROUP = "$Default"

async def on_event(partition_context, event):
    """Her sipariş değişikliği için tetiklenir."""
    try:
        body = event.body_as_str(encoding="UTF-8")
        envelope = json.loads(body)

        # CloudEvents standart alanlar
        event_type = envelope.get("type")
        subject = envelope.get("subject")
        commit_ts = envelope.get("commit_timestamp")

        # İçerik
        data = envelope.get("data", {})
        operation = data.get("operation")
        after = data.get("after", {})

        print(f"[{commit_ts}] {operation} on {subject}: {after}")

        # İş mantığı: yeni sipariş geldiyse müşteri bildirimi
        if event_type == "Microsoft.SqlServer.RowChange.Insert":
            await handle_new_order(after)
        elif event_type == "Microsoft.SqlServer.RowChange.Update":
            await handle_order_update(data.get("before"), after)

        # Checkpoint
        await partition_context.update_checkpoint(event)

    except Exception as e:
        print(f"Error: {e}")

async def handle_new_order(order):
    print(f"Yeni sipariş #{order['order_id']} işleniyor...")
    # Customer service'e bildir, payment processor'a yolla vb.

async def handle_order_update(before, after):
    if before["status"] != after["status"]:
        print(f"Sipariş #{after['order_id']} durumu: {before['status']} -> {after['status']}")

async def main():
    credential = DefaultAzureCredential()
    consumer = EventHubConsumerClient(
        fully_qualified_namespace=EVENT_HUB_NAMESPACE,
        eventhub_name=EVENT_HUB_NAME,
        consumer_group=CONSUMER_GROUP,
        credential=credential
    )

    async with consumer:
        await consumer.receive(
            on_event=on_event,
            starting_position="@latest"
        )

if __name__ == "__main__":
    asyncio.run(main())

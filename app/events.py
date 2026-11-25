
from datetime import datetime, timezone


def get_cargo_events():
    return [
        {
            "awb": "125-12345675",
            "event": "Shipment Received",
            "status": "SUCCESS",
            "location": "Heathrow",
            "timestamp": datetime.now(timezone.utc).isoformat()
        },
        {
            "awb": "125-12345676",
            "event": "Security Screening",
            "status": "SUCCESS",
            "location": "Heathrow",
            "timestamp": datetime.now(timezone.utc).isoformat()
        },
        {
            "awb": "125-12345677",
            "event": "ULD Build-up",
            "status": "FAILED",
            "location": "Heathrow",
            "timestamp": datetime.now(timezone.utc).isoformat()
        },
        {
            "awb": "125-12345678",
            "event": "Shipment Dispatched",
            "status": "SUCCESS",
            "location": "Heathrow",
            "timestamp": datetime.now(timezone.utc).isoformat()
        }
    ]


def get_event_summary(events):
    total = len(events)
    failed = sum(1 for event in events if event["status"] == "FAILED")

    return {
        "total_events": total,
        "successful_events": total - failed,
        "failed_events": failed
    }

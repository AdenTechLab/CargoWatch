
from flask import Flask, jsonify
from datetime import datetime, timezone

from app.events import get_cargo_events, get_event_summary

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify({
        "application": "CargoWatch",
        "description": "Air Cargo Operations Monitoring Platform",
        "version": "1.0.0",
        "status": "running"
    })


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat()
    }), 200


@app.route("/api/cargo/events")
def cargo_events():
    events = get_cargo_events()

    return jsonify({
        "summary": get_event_summary(events),
        "events": events
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

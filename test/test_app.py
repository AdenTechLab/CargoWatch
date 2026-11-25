
import pytest
from app.main import app


@pytest.fixture
def client():
    app.config["TESTING"] = True

    with app.test_client() as client:
        yield client


def test_home_endpoint(client):
    response = client.get("/")

    assert response.status_code == 200
    assert response.json["application"] == "CargoWatch"


def test_health_endpoint(client):
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json["status"] == "healthy"


def test_cargo_events_endpoint(client):
    response = client.get("/api/cargo/events")

    assert response.status_code == 200
    assert response.json["summary"]["total_events"] == 4
    assert response.json["summary"]["failed_events"] == 1

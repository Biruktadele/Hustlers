import pytest
from unittest.mock import AsyncMock, MagicMock
from app.services.telegram_service import TelegramService

@pytest.fixture
def telegram_service():
    service = TelegramService()
    # Mock the client
    service.client = AsyncMock()
    return service

@pytest.mark.asyncio
async def test_get_group_posts(telegram_service):
    # Mock the entity
    mock_entity = MagicMock()
    telegram_service.client.get_entity.return_value = mock_entity

    # Mock messages
    mock_message = MagicMock()
    mock_message.id = 1
    mock_message.message = "Test message"
    mock_message.date.isoformat.return_value = "2023-01-01T00:00:00"
    mock_message.sender_id = 123
    mock_message.views = 10
    mock_message.forwards = 2

    telegram_service.client.get_messages.return_value = [mock_message]

    posts = await telegram_service.get_group_posts("test_group", limit=1)

    assert len(posts) == 1
    assert posts[0]['id'] == 1
    assert posts[0]['text'] == "Test message"
    assert posts[0]['date'] == "2023-01-01T00:00:00"
    assert posts[0]['sender_id'] == 123
    assert posts[0]['views'] == 10
    assert posts[0]['forwards'] == 2

    telegram_service.client.start.assert_called_once()
    telegram_service.client.get_entity.assert_called_once_with("test_group")
    telegram_service.client.get_messages.assert_called_once_with(mock_entity, limit=1)
    telegram_service.client.disconnect.assert_called_once()

@pytest.mark.asyncio
async def test_get_group_info(telegram_service):
    # Mock the entity
    mock_entity = MagicMock()
    mock_entity.id = 456
    mock_entity.title = "Test Group"
    mock_entity.username = "testgroup"
    mock_entity.participants_count = 100

    telegram_service.client.get_entity.return_value = mock_entity

    info = await telegram_service.get_group_info("test_group")

    assert info['id'] == 456
    assert info['title'] == "Test Group"
    assert info['username'] == "testgroup"
    assert info['participants_count'] == 100
    assert info['type'] == 'group'  # Since not Channel

    telegram_service.client.start.assert_called_once()
    telegram_service.client.get_entity.assert_called_once_with("test_group")
    telegram_service.client.disconnect.assert_called_once()
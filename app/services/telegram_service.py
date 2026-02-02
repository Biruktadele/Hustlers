from telethon import TelegramClient
from telethon.tl.types import Channel
from typing import List, Dict
import asyncio
from app.core.config import settings

class TelegramService:
    def __init__(self):
        self.api_id = settings.telegram_api_id
        self.api_hash = settings.telegram_api_hash
        self.client = TelegramClient('session_name', self.api_id, self.api_hash)

    async def get_group_posts(self, group_username: str, limit: int = 10) -> List[Dict]:
        """
        Get recent posts from a Telegram group/channel.

        Args:
            group_username: The username or ID of the group/channel
            limit: Number of posts to retrieve

        Returns:
            List of post dictionaries with message details
        """
        await self.client.start()

        try:
            # Get the entity (group/channel)
            entity = await self.client.get_entity(group_username)

            # Get messages
            messages = await self.client.get_messages(entity, limit=limit)

            posts = []
            for message in messages:
                if message.message:  # Only text messages
                    post = {
                        'id': message.id,
                        'text': message.message,
                        'date': message.date.isoformat(),
                        'sender_id': message.sender_id,
                        'views': getattr(message, 'views', None),
                        'forwards': getattr(message, 'forwards', None),
                    }
                    posts.append(post)

            return posts

        finally:
            await self.client.disconnect()

    async def get_group_info(self, group_username: str) -> Dict:
        """
        Get information about a Telegram group/channel.

        Args:
            group_username: The username or ID of the group/channel

        Returns:
            Dictionary with group information
        """
        await self.client.start()

        try:
            entity = await self.client.get_entity(group_username)

            info = {
                'id': entity.id,
                'title': getattr(entity, 'title', ''),
                'username': getattr(entity, 'username', ''),
                'participants_count': getattr(entity, 'participants_count', None),
                'type': 'channel' if isinstance(entity, Channel) else 'group'
            }

            return info

        finally:
            await self.client.disconnect()

# Global instance
telegram_service = TelegramService()
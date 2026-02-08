from telethon import TelegramClient
from telethon.sessions import StringSession
from telethon.tl.types import Channel
from typing import List, Dict
import asyncio
import json
from app.core.config import settings
from datetime import datetime

class TelegramService:
    def __init__(self):
        self.api_id = settings.telegram_api_id
        self.api_hash = settings.telegram_api_hash
        if not settings.telegram_session:
            raise ValueError("TELEGRAM_SESSION is required for TelegramService")
        self.client = TelegramClient(StringSession(settings.telegram_session), self.api_id, self.api_hash)

    async def get_group_posts(self, group_username: str, limit=None, date_range=None) -> List[Dict]:

        await self.client.start()

        try:
            # Get the entity (group/channel)
            entity = await self.client.get_entity(group_username)

            # Fetch messages based on the provided limit or date range
            if date_range:
                start_date, end_date = date_range
                messages = self.client.iter_messages(entity, offset_date=start_date, reverse=True)
                messages = [msg async for msg in messages if msg.date <= end_date]
            else:
                messages = await self.client.get_messages(entity, limit=limit)

            posts = []
            for message in messages:
                if message.message:  # Only text messages
                    deep_link = None
                    if message.reply_markup and message.reply_markup.rows and message.reply_markup.rows[0].buttons:
                        button = message.reply_markup.rows[0].buttons[0]
                        if hasattr(button, 'url'):
                            deep_link = button.url
                        
                    
                    message.deep_link = deep_link
                    posts.append(message.__dict__)
                # print(message)
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

            # info = {
            #     'id': entity.id,
            #     'title': getattr(entity, 'title', ''),
            #     'username': getattr(entity, 'username', ''),
            #     'participants_count': getattr(entity, 'participants_count', None),
            #     'type': 'channel' if isinstance(entity, Channel) else 'group'
            # }

            return entity.__dict__

        finally:
            await self.client.disconnect()

# Global instance
telegram_service = TelegramService()
from telethon.sessions import StringSession
from telethon.sync import TelegramClient

api_id = 33803519
api_hash = "f7766d13bbcc10eddf66beb36cac0c8e"

with TelegramClient(StringSession(), api_id, api_hash) as client:
    print('\nYour TELEGRAM_SESSION is:\n')
    print(client.session.save())
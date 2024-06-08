# MultiSigHelperBot

MultiSigHelperBot is a Telegram bot designed to assist with operating large multisig setups. 

## Getting Started

Prerequisites:

* Docker and Docker Compose installed on your system.
* A Telegram bot token from BotFather.

Installation:

```
git clone https://github.com/yourusername/MultiSigHelperBot.git
cd MultiSigHelperBot
```

Create a .env file with your environment variables:

```
TGBOTTOKEN=your_telegram_bot_token
REDEEMSCRIPT=
```

Build and run the Docker container:

> podman-compose up --build

## Usage

Start a chat with your Telegram bot.

> /help

## Building from Source

If you prefer to build the bot from source without containers, ensure you have the Dart SDK installed and follow these steps:

Install dependencies:

> dart pub get

Compile the bot:

> dart compile exe bin/multisighelper.dart -o bin/multisighelper

Run the bot:

> ./bin/multisighelper

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your changes.
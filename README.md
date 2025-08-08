# openrouter.ai in Terminal

Simple terminal app to use OpenRouter.ai with your personal API keys. Ask questions directly from your terminal and get AI responses instantly. 

Please note that free models on openrouter.ai (those with :free in their slug) are typically limited to 50 requests per day if you have not purchased credits. A request on OpenRouter.ai is defined as a single API call or message sent to the model—essentially, each question or prompt you send, regardless of its length or the number of tokens involved. For 99% of people using this script, is more that enough. These limits apply per account, not per model. Switching between free models does not reset your daily quota. Please read their documentation for more: https://openrouter.ai/settings/credits

## Features
 - 🚀 Minimalist CLI interface — talk to AI directly from your terminal.
 - 🔑 Secure API key & model config — stored in .env file (create it by copiing .env.example), no need to enter every time.
 - 🔄 Easy update: Run `ai.sh --update` to get the latest version.
 - 📖 Built-in help: Run `ai.sh --help` for usage instructions.
 - 🤖 Full session memory — ongoing conversations with proper context (stateful chat).
 - 💬 Natural language queries — just type like you're talking to a buddy.
 - 💾 Chat history saved — all conversations stored as timestamped .txt files inside `chat_sessions/`.
 - 🧠 Dynamic AI name display — bot replies are labeled with the selected model (e.g. Mistral AI:).
 - 👤 Personalized & interactive input — uses your system username in the prompt and supports arrow keys for editing your message like a real terminal app.
 - 🧹 Clean output — only the answer, no JSON noise.
 - 🆓 Uses a free model by default — no paid account required only your API key.
 - 🔍 Smart package manager detection — if curl or jq is missing, the script tells you exactly how to install it (e.g. `sudo pacman -S jq)`.
 - 🧪 Works on Linux & macOS and Windows through WLS — tested on Arch-based, Debian-based and macOS (via brew).
 - ✨ Zero dependencies beyond `curl` and `jq` — no Python, no Node.js, no drama.
 - 🐞 Debug mode support — run with `DEBUG=true ai.sh` to see full raw API responses on errors in the terminal.
 - 🧼 Session history is always clean — error messages are never saved in the logs, whether debug mode is on or off (default).

### Important Note
This CLI tool now supports ongoing, contextual chat with the AI.
Unlike the old one-shot version (ask once, get one reply), this new version maintains the full conversation history during a session — so you can chat back and forth naturally, with context.

## Prerequisites

- `curl` (usually pre-installed on most systems)
- `jq` for JSON parsing

### Installing jq

**Ubuntu/Debian based:**
```bash
sudo apt install jq
```

**CentOS/RHEL/Fedora based:**
```bash
sudo yum install jq
# or for newer versions:
sudo dnf install jq
```

**Arch based (btw):**
```bash
sudo pacman -S jq
```

**macOS:**
```bash
brew install jq
```

**Windows (WSL):**
```bash
sudo apt install jq
```

## Installation

1. **Clone or download this repository:**
   ```bash
   git clone https://github.com/SynergOps/openrouter.ai
   cd openrouter.ai
   ```

2. **Ensure the script is executable:**
   ```bash
   chmod +x ai.sh
   ```

3. **Get your OpenRouter API key:**
   - Go to [OpenRouter.ai](https://openrouter.ai/)
   - Sign up with your Github account for a free account
   - Navigate to models and then the Mistral Small 3.2 24B (free) 
   - Click API keys section
   - Generate a new API key

4. **Configure your API key and model:**
   - Copy the example environment file and edit it:
   ```bash
   cp .env.example .env
   vim .env
   ```
   - Add your API key and optionally configure the model:
   ```
   # OpenRouter API Configuration
   OPENROUTER_API_KEY=sk-or-v1-your-actual-api-key-here
   # OpenRouter Model Configuration (optional - leave empty for default)
   OPENROUTER_MODEL=
   ```
   - See `.models` for a list of available models. Do not edit `.models` directly.

## Usage

### Update & Help

- To update the script to the latest version:
   ```bash
   ./ai.sh --update
   ```

- To show usage instructions:
   ```bash
   ./ai.sh --help
   ```
## Creating a Terminal Alias (Recommended)

For easier access, you can create an alias so you can use the script from anywhere without typing the full path:

**Option 1: Temporary alias (current session only)**
```bash
alias ai='/path/to/your/openrouter.ai/ai.sh'
```

**Option 2: Permanent alias (recommended)**

1. **For Bash users** - Add to your `~/.bashrc` or `~/.bash_profile`:
   ```bash
   cd /path/to/your/openrouter.ai
   echo "alias ai='$(pwd)/ai.sh'" >> ~/.bashrc
   source ~/.bashrc
   ```

2. **For Zsh users** - Add to your `~/.zshrc`:
   ```bash
   cd /path/to/your/openrouter.ai
   echo "alias ai='$(pwd)/ai.sh'" >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Manual method** - Edit your shell config file:
   ```bash
   # Open your shell config file
   nano ~/.bashrc  # or ~/.zshrc for Zsh users
   
   # Add this line (replace with your actual path):
   alias ai='/full/path/to/openrouter.ai/ai.sh'
   
   # Reload your shell config
   source ~/.bashrc  # or source ~/.zshrc
   ```

**After setting up the alias, you can use it from anywhere:**
```bash
# Instead of ./ai.sh question
# Works from any directory
cd ~/Documents
ai
```
## Basic Usage with Sample Output

```bash
$ ai

💬 Start a conversation! Type your message and press Enter (Ctrl+C to exit)

🧑 cerebrux: What's the capital of Greece?

🤖 Mistral AI:
Athens is both the historical heart and the modern capital of Greece

🧑 cerebrux: Did they have a co-capital there?

🤖 Mistral AI:
Thessaloniki is widely recognized as Greece's "second city" due to its size and economic 
power.
The term "co-capital" (**συμπρωτεύουσα** - symprotévousa) when applied to Thessaloniki 
is an honorary, historical, and cultural designation reflecting its immense importance.
```
### 🐛 Debug Mode : Showing Error Messages with DEBUG

By default, the error messages are mostly, user friendly:
```bash
$ ai.sh           

💬 Start a conversation! Type your message and press Enter (Ctrl+C for exit)

🧑 cerebrux: Hi!

❌ API Error: No auth credentials found
```
If you encounter any kind of a similar problem you can enable the debugging mode to get a more verbose output that may help us pinpoint the problem and fix it. To enable raw API response output for troubleshooting, run the script with:

```bash
$ DEBUG=true ai

💬 Start a conversation! Type your message and press Enter (Ctrl+C for exit)

🧑 cerebrux: Hi!

❌ API Error: No auth credentials found

🔍 Full response for debugging:
{
  "error": {
    "message": "No auth credentials found",
    "code": 401
  }
}
```

## Configuration

### Changing the AI Model

You can change the AI model by editing the `OPENROUTER_MODEL` variable in your `.env` file. For available models, refer to the `.models` file in the repository root. Copy the desired model slug from `.models` and set it in your `.env`:

```bash
# Leave empty or unset to use the default model
OPENROUTER_MODEL=

# Example:
OPENROUTER_MODEL=qwen/qwq-32b:free
```

**Note:** If `OPENROUTER_MODEL` is not set or left empty, the script will use the default Mistral model. Do not edit `.models` directly.

### Common Issues

1. **"jq: command not found"**
   - Install jq using the instructions above

2. **"Error: .env file not found"**
   - Make sure you have a `.env` file in the same directory as `ai.sh`
   - Check that your API key is properly set in the `.env` file

3. **"Error: OPENROUTER_API_KEY is not set"**
   - Verify your `.env` file contains: `OPENROUTER_API_KEY=your-actual-key`
   - Make sure there are no extra spaces around the `=` sign

4. **Empty, Invalid model, or other errors**
   - Check that your `OPENROUTER_MODEL` setting in `.env` is correct
   - Verify the model name is available on OpenRouter
   - Leave `OPENROUTER_MODEL=` empty to use the default model

5. **Empty or error responses**
   - Carefully read the message response and act accordingly
   - Verify your API key is valid and active
   - Check your internet connection
   - Ensure you haven't exceeded any rate limits

## License

This project is licensed under the Apache 2.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## Support

If you encounter any issues or have questions, please open an issue on GitHub.

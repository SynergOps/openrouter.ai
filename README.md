# openrouter.ai in Terminal

Simple terminal app to use OpenRouter.ai with your personal API keys. Ask questions directly from your terminal and get AI responses instantly. 

Please note that free models on openrouter.ai (those with :free in their slug) are typically limited to 50 requests per day if you have not purchased credits. A request on OpenRouter.ai is defined as a single API call or message sent to the model—essentially, each question or prompt you send, regardless of its length or the number of tokens involved. For 99% of people using this script, is more that enough. These limits apply per account, not per model. Switching between free models does not reset your daily quota. Please read their documentation for more: https://openrouter.ai/settings/credits

## Features

- 🚀 Simple command-line interface
- 🔑 Secure API key and model management with `.env` file
- 🎯 Clean output (only the AI response, no JSON clutter)
- 💬 Natural language queries
- 🆓 Uses free Mistral model by default
- ⚡ **Stateless design** - each query is independent (no conversation history between queries)
- 📝 **Conversation History Storage** - All chat sessions are saved as text files in the `chat_sessions` folder for later reference

### Important Note

This tool is designed for **single-question interactions** - each query is independent with no memory of previous conversations (Stateless design). However, it **stores conversation history** for your convenience. Each time you run the script, it saves both your question and the AI's response to text files in the `chat_sessions` folder. The files are named using the first sentence of your question, making it easy to find and review previous conversations. If you ask the exact same question again, the new response will be appended to the existing file.


## Prerequisites

- `curl` (usually pre-installed on most systems)
- `jq` for JSON parsing

### Installing jq

**Ubuntu/Debian:**
```bash
sudo apt install jq
```

**CentOS/RHEL/Fedora:**
```bash
sudo yum install jq
# or for newer versions:
sudo dnf install jq
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
   - while you are in the openrouter folder, edit the `.env` file template and add your API key:
   ```bash
   vim .env
   ```
   - Add your API key and optionally configure the model:
   ```
   # OpenRouter API Configuration
   OPENROUTER_API_KEY=sk-or-v1-your-actual-api-key-here
   # OpenRouter Model Configuration (optional - leave empty for default)
   OPENROUTER_MODEL=
   ```

## Usage

### Basic Usage

```bash
./ai.sh your question here
```
### Examples

```bash
# Ask a simple question
./ai.sh what is the meaning of life

# Ask for coding help
./ai.sh how do I create a function in Python

# Ask for a definition
./ai.sh define recursion

# Ask for a summary
./ai.sh summarize the plot of "The Hitchhiker's Guide to the Galaxy"
```

### Sample Output

```bash
$ ./ai.sh what is the meaning of 42
The number 42 is famously known as "The Answer to the Ultimate Question of Life, the Universe, and Everything" from Douglas Adams' science fiction series "The Hitchhiker's Guide to the Galaxy."
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
ai explain machine learning
```

## Configuration

### Changing the AI Model

You can change the AI model by editing the `OPENROUTER_MODEL` variable in your `.env` file. The `.env` file now includes a comprehensive list of free models - simply uncomment the one you want to use:

```bash
# Leave empty or unset to use the default model
OPENROUTER_MODEL=

# Or uncomment one of the many free models listed in .env
# OPENROUTER_MODEL=qwen/qwq-32b:free
# OPENROUTER_MODEL=deepseek/deepseek-r1-0528:free
# OPENROUTER_MODEL=google/gemini-2.0-flash-exp:free
```
Check your `.env` file for the complete list.

**Note:** If `OPENROUTER_MODEL` is not set or left empty, the script will use the default Mistral model. Simply uncomment one of the free models in your `.env` file to use a different model.

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

### Debug Mode

The script automatically shows the full JSON response when it encounters errors or unexpected responses. If you need to see the raw API response for debugging purposes, the script will display it when:
- The API returns an error
- The response format is unexpected
- The content cannot be extracted properly

This provides all the debugging information you need without manually modifying the script.

## License

This project is licensed under the Apache 2.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## Support

If you encounter any issues or have questions, please open an issue on GitHub.

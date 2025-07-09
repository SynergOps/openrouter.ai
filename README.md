# openrouter.ai in Terminal

Simple terminal app to use OpenRouter.ai with your personal API keys. Ask questions directly from your terminal and get AI responses instantly.

## Features

- 🚀 Simple command-line interface
- 🔑 Secure API key management with `.env` file
- 🎯 Clean output (only the AI response, no JSON clutter)
- 💬 Natural language queries
- 🆓 Uses free Mistral model by default

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
sudo apt-get install jq
```

## Installation

1. **Clone or download this repository:**
   ```bash
   git clone https://github.com/yourusername/openrouter.ai.git
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

4. **Configure your API key:**
   - Copy the `.env` file template and add your API key:
   ```bash
   # Edit the .env file
   nano .env
   ```
   - Replace `your_api_key_here` with your actual API key:
   ```
   OPENROUTER_API_KEY=sk-or-v1-your-actual-api-key-here
   ```

## Usage

### Basic Usage

```bash
./ai.sh your question here
```

### Creating a Terminal Alias (Recommended)

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

## Configuration

### Changing the AI Model

You can modify the `ai.sh` script to use different models available on OpenRouter. Edit the `model` field in the script:

```json
"model": "mistralai/mistral-small-3.2-24b-instruct:free"
```

Popular free models on OpenRouter include:
- `qwen/qwq-32b:free`
- `deepseek/deepseek-r1-0528:free`
- `google/gemini-2.0-flash-exp:free`

### Common Issues

1. **"jq: command not found"**
   - Install jq using the instructions above

2. **"Error: .env file not found"**
   - Make sure you have a `.env` file in the same directory as `ai.sh`
   - Check that your API key is properly set in the `.env` file

3. **"Error: OPENROUTER_API_KEY is not set"**
   - Verify your `.env` file contains: `OPENROUTER_API_KEY=your-actual-key`
   - Make sure there are no extra spaces around the `=` sign

4. **Empty or error responses**
   - Verify your API key is valid and active
   - Check your internet connection
   - Ensure you haven't exceeded any rate limits

### Debug Mode

To see the full JSON response (useful for debugging), temporarily remove the `| jq -r '.choices[0].message.content'` part from the curl command in `ai.sh`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## Support

If you encounter any issues or have questions, please open an issue on GitHub.

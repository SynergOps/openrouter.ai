#!/bin/bash
# OpenRouter CLI Chat in BASH
# License: Apache-2.0
# Usage: ./ai.sh to start interactive terminal chatbot
# Optional: Run with DEBUG=true to enable detailed error debugging, e.g.:
# DEBUG=true ./ai.sh

# Update option: run git pull and exit
if [[ "$1" == "--update" ]]; then
  echo "🔄 Updating ai.sh to the latest version..."
  cd "$SCRIPT_DIR" && git pull
  exit $?
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if a command exists; if missing, suggest how to install its package based on detected package manager
check_dependency() {
  local cmd=$1
  local pkg=$2

  if ! command -v "$cmd" &> /dev/null; then
    echo "🚫 Missing dependency: $cmd"

    if [[ "$(uname)" == "Darwin" ]]; then
      echo "Try: brew install $pkg and come back!"
      exit 1
    elif command -v pacman &> /dev/null; then
      echo "Try: sudo pacman -S $pkg and come back!"
      exit 1
    elif command -v apt &> /dev/null; then
      echo "Try: sudo apt install $pkg and come back!"
      exit 1
    elif command -v dnf &> /dev/null; then
      echo "Try: sudo dnf install $pkg and come back!"
      exit 1
    elif command -v yum &> /dev/null; then
      echo "Try: sudo yum install $pkg and come back!"
      exit 1
    elif command -v zypper &> /dev/null; then
      echo "Try: sudo zypper install $pkg and come back!"
      exit 1
    else
      echo "Come back when you install $cmd!"
      exit 1
    fi

  fi
}

# Checking dependencies
check_dependency curl curl
check_dependency jq jq

# Load .env file
if [[ -f "$SCRIPT_DIR/.env" ]]; then
  source "$SCRIPT_DIR/.env"
else
  echo "❌ .env file not found in $SCRIPT_DIR"
  exit 1
fi

# Check API Key
if [[ -z "$OPENROUTER_API_KEY" ]]; then
  echo "❌ The OPENROUTER_API_KEY is missing from .env file."
  exit 1
fi

# Default AI Model
if [[ -z "$OPENROUTER_MODEL" ]]; then
  OPENROUTER_MODEL="mistralai/mistral-small-3.2-24b-instruct:free"
fi

# Folder creation
CHAT_LOG_DIR="$SCRIPT_DIR/chat_sessions"
mkdir -p "$CHAT_LOG_DIR"

DATE_STR=$(date '+%Y-%m-%d_%H-%M-%S')
SESSION_FILE="$CHAT_LOG_DIR/session_$DATE_STR.txt"

# Initialize conversation history array
CHAT_HISTORY=()

echo -e "\n💬 Start a conversation! Type your message and press Enter (Ctrl+C for exit)\n"

DEBUG=${DEBUG:-false}

while true; do
  # Interactive user input
  read -e -p "🧑 $USER: " USER_INPUT

  # Skip iteration if input is empty
  [[ -z "$USER_INPUT" ]] && continue

  # Append the user’s input to the chat history array
  CHAT_HISTORY+=("$USER_INPUT")

  # Build JSON array of messages alternating roles (user/assistant) from chat history, escaping quotes properly
  JSON_MESSAGES="["
  for ((i=0; i<${#CHAT_HISTORY[@]}; i++)); do
    if (( i % 2 == 0 )); then
      ROLE="user"
    else
      ROLE="assistant"
    fi
    ESCAPED=$(printf "%s" "${CHAT_HISTORY[i]}" | sed 's/"/\\"/g')
    JSON_MESSAGES+="{\"role\":\"$ROLE\",\"content\":[{\"type\":\"text\",\"text\":\"$ESCAPED\"}]},"
  done
  JSON_MESSAGES="${JSON_MESSAGES%,}]"

  # API request
  RESPONSE=$(curl -s https://openrouter.ai/api/v1/chat/completions \
    -H "Authorization: Bearer $OPENROUTER_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
      \"model\": \"$OPENROUTER_MODEL\",
      \"messages\": $JSON_MESSAGES
    }")

  # Check for API errors; if found, show error message and, if DEBUG=true, display full JSON response for troubleshooting.
  # Skip saving error responses to chat history.
  ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error.message // empty')
  if [[ -n "$ERROR_MSG" ]]; then
    echo -e "\n❌ API Error: $ERROR_MSG\n"
    if [[ "$DEBUG" == "true" ]]; then
      echo "🔍 Full response for debugging:"
      echo "$RESPONSE" | jq .
    fi
    continue
  fi

  # Extract the AI's reply text from the JSON response
  BOT_REPLY=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')

  # Extract AI Model name for display purposes

  BOT_NAME_RAW="$OPENROUTER_MODEL"
  BOT_NAME_WITH_DASHES="${BOT_NAME_RAW#*/}"
  BOT_NAME_WITH_DASHES="${BOT_NAME_WITH_DASHES%%:*}"
  BOT_NAME="${BOT_NAME_WITH_DASHES%%-*}"
  BOT_DISPLAY_NAME="$(tr '[:lower:]' '[:upper:]' <<< "${BOT_NAME:0:1}")${BOT_NAME:1} AI"

  # Print the AI response to the terminal with formatting
  echo -e "\n\033[1;32m🤖 $BOT_DISPLAY_NAME:\033[0m\n"
  TERM_WIDTH=$(tput cols 2>/dev/null || echo 100)
  echo "$BOT_REPLY" | fold -s -w "$TERM_WIDTH"
  echo


  # Append the current exchange to the session file (user + AI reply)
  {
    echo "🧑 $USER: $USER_INPUT"
    echo
    echo "🤖 $BOT_DISPLAY_NAME:"
    echo
    echo "$BOT_REPLY" | fold -s -w 100
    echo "------------------------------------------------------------"
  } >> "$SESSION_FILE"

  # Add the AI reply to the chat history array for context
  CHAT_HISTORY+=("$BOT_REPLY")
done

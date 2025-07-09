#!/bin/bash
# This script interacts with the OpenRouter API to ask questions using the Mistral AI model.
# license: Apache-2.0
# Usage: ./ai.sh <your question> 
# Example: ./ai.sh What is the meaning of 42

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if required binaries are installed
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install curl first."
    echo "Ubuntu/Debian: sudo apt-get install curl"
    echo "CentOS/RHEL: sudo yum install curl"
    echo "macOS: curl is usually pre-installed, or use 'brew install curl'"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq first."
    echo "Ubuntu/Debian: sudo apt-get install jq"
    echo "CentOS/RHEL: sudo yum install jq"
    echo "macOS: brew install jq"
    exit 1
fi

# Source the .env file from the script's directory
if [ -f "$SCRIPT_DIR/.env" ]; then
    source "$SCRIPT_DIR/.env"
else
    echo "Error: .env file not found in $SCRIPT_DIR. Please create a .env file with your OPENROUTER_API_KEY."
    exit 1
fi

# Check if API key is set
if [ -z "$OPENROUTER_API_KEY" ]; then
    echo "Error: OPENROUTER_API_KEY is not set in .env file."
    exit 1
fi

# Check if user provided a question
if [ $# -eq 0 ]; then
    echo "Usage: $0 <your question>"
    echo "Example: $0 what is the meaning of 42"
    exit 1
fi

# Combine all arguments into a single question
QUESTION="$*"

# Make the API call with the user's question and extract only the content
RESPONSE=$(curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -d "{
  \"model\": \"mistralai/mistral-small-3.2-24b-instruct:free\",
  \"messages\": [
    {
      \"role\": \"user\",
      \"content\": [
        {
          \"type\": \"text\",
          \"text\": \"$QUESTION\"
        }
      ]
    }
  ]
}")

# Check if we got a valid response
if [ -z "$RESPONSE" ]; then
    echo "Error: No response from API. Check your internet connection."
    exit 1
fi

# Try to extract the content, but show full response if it fails
CONTENT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null)

if [ "$CONTENT" = "null" ] || [ -z "$CONTENT" ]; then
    echo "Error: Unexpected API response. Full response:"
    echo "$RESPONSE" | jq . 2>/dev/null || echo "$RESPONSE"
    exit 1
else
    echo "$CONTENT"
fi

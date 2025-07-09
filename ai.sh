#!/bin/bash

# Source the .env file to load environment variables
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found. Please create a .env file with your OPENROUTER_API_KEY."
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
curl -s https://openrouter.ai/api/v1/chat/completions \
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
}" | jq -r '.choices[0].message.content'

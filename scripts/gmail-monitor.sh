#!/bin/bash

# Gmail Monitor via Maton API Bridge
# Alternative to himalaya IMAP when Gmail OAuth is active in Maton

MATON_API_KEY="${MATON_API_KEY:-$(cat ~/.openclaw/workspace/.maton-api-key 2>/dev/null)}"
MATON_BASE="https://gateway.maton.ai/google-mail/gmail/v1/users/me"

if [ -z "$MATON_API_KEY" ]; then
  echo "✗ Error: MATON_API_KEY not set"
  exit 1
fi

case "$1" in
  list)
    # List recent messages
    curl -s -H "Authorization: Bearer $MATON_API_KEY" \
      "$MATON_BASE/messages?maxResults=10&q=is:unread" | jq '.messages // []'
    ;;
  
  count-unread)
    # Count unread emails
    COUNT=$(curl -s -H "Authorization: Bearer $MATON_API_KEY" \
      "$MATON_BASE/messages?q=is:unread" | jq '.resultSizeEstimate // 0')
    echo "$COUNT"
    ;;
  
  search)
    # Search emails: gmail-monitor.sh search "from:john@example.com"
    QUERY="${2:-is:unread}"
    curl -s -H "Authorization: Bearer $MATON_API_KEY" \
      "$MATON_BASE/messages?q=$(echo -n "$QUERY" | jq -sRr @uri)" | jq '.messages // []'
    ;;
  
  read)
    # Read message: gmail-monitor.sh read <message-id>
    MSG_ID="$2"
    curl -s -H "Authorization: Bearer $MATON_API_KEY" \
      "$MATON_BASE/messages/$MSG_ID" | jq '.snippet // .payload.body.data'
    ;;
  
  *)
    echo "Gmail Monitor via Maton API"
    echo ""
    echo "Usage:"
    echo "  gmail-monitor.sh list              # List unread emails"
    echo "  gmail-monitor.sh count-unread      # Count unread"
    echo "  gmail-monitor.sh search QUERY      # Search emails (e.g., 'from:...')"
    echo "  gmail-monitor.sh read MSG_ID       # Read specific message"
    ;;
esac

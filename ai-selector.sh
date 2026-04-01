#!/usr/bin/env bash
# ai-selector: Cost comparison + model selection for prompts
# Usage: ./ai-selector.sh "your prompt here"

set -euo pipefail

PROMPT="${1:-}"

if [[ -z "$PROMPT" ]]; then
  echo "❌ Usage: ai-selector.sh \"your prompt\""
  exit 1
fi

# Token estimation: ~1.3 chars per token (English average)
PROMPT_LEN=${#PROMPT}
EST_INPUT_TOKENS=$((PROMPT_LEN / 3 + 1))
EST_OUTPUT_TOKENS=$((EST_INPUT_TOKENS * 2))

# Pricing per million tokens (2026-03-20)
CLAUDE_OPUS_INPUT_PRICE=15000       # $15/MTok
CLAUDE_OPUS_OUTPUT_PRICE=45000      # $45/MTok
GPT_54_PRO_INPUT_PRICE=32000        # $32/MTok
GPT_54_PRO_OUTPUT_PRICE=128000      # $128/MTok
GEMINI_31_PRO_INPUT_PRICE=2500      # $2.50/MTok
GEMINI_31_PRO_OUTPUT_PRICE=10000    # $10/MTok

# Calculate costs
CLAUDE_INPUT_COST=$((EST_INPUT_TOKENS * CLAUDE_OPUS_INPUT_PRICE / 1000000))
CLAUDE_OUTPUT_COST=$((EST_OUTPUT_TOKENS * CLAUDE_OPUS_OUTPUT_PRICE / 1000000))
CLAUDE_TOTAL=$((CLAUDE_INPUT_COST + CLAUDE_OUTPUT_COST))

GPT_INPUT_COST=$((EST_INPUT_TOKENS * GPT_54_PRO_INPUT_PRICE / 1000000))
GPT_OUTPUT_COST=$((EST_OUTPUT_TOKENS * GPT_54_PRO_OUTPUT_PRICE / 1000000))
GPT_TOTAL=$((GPT_INPUT_COST + GPT_OUTPUT_COST))

GEMINI_INPUT_COST=$((EST_INPUT_TOKENS * GEMINI_31_PRO_INPUT_PRICE / 1000000))
GEMINI_OUTPUT_COST=$((EST_OUTPUT_TOKENS * GEMINI_31_PRO_OUTPUT_PRICE / 1000000))
GEMINI_TOTAL=$((GEMINI_INPUT_COST + GEMINI_OUTPUT_COST))

# Format output
format_cost() {
  local cents=$1
  printf "\$%d.%02d" $((cents / 100)) $((cents % 100))
}

cat <<EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖 AI Model Cost Comparison
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Estimated tokens: ~${EST_INPUT_TOKENS} input, ~${EST_OUTPUT_TOKENS} output

1️⃣  Claude Opus 4.6
    Cost: $(format_cost $CLAUDE_TOTAL)
    (input: $(format_cost $CLAUDE_INPUT_COST) + output: $(format_cost $CLAUDE_OUTPUT_COST))

2️⃣  GPT-5.4 Pro
    Cost: $(format_cost $GPT_TOTAL)
    (input: $(format_cost $GPT_INPUT_COST) + output: $(format_cost $GPT_OUTPUT_COST))

3️⃣  Gemini 3.1 Pro
    Cost: $(format_cost $GEMINI_TOTAL)
    (input: $(format_cost $GEMINI_INPUT_COST) + output: $(format_cost $GEMINI_OUTPUT_COST))

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Select model (1-3) or press Ctrl+C to cancel
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# Read selection
read -p "Your choice: " choice

case "$choice" in
  1)
    echo "✅ Selected: Claude Opus 4.6"
    # Save state for agent to pick up
    cat > /tmp/ai-selector-state.json <<JSON
{
  "model": "anthropic/claude-opus-4-6",
  "prompt": "$PROMPT",
  "cost": "$CLAUDE_TOTAL",
  "selected_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
JSON
    echo "💾 Saved to /tmp/ai-selector-state.json"
    ;;
  2)
    echo "✅ Selected: GPT-5.4 Pro"
    cat > /tmp/ai-selector-state.json <<JSON
{
  "model": "openai/gpt-5.4-pro",
  "prompt": "$PROMPT",
  "cost": "$GPT_TOTAL",
  "selected_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
JSON
    echo "💾 Saved to /tmp/ai-selector-state.json"
    ;;
  3)
    echo "✅ Selected: Gemini 3.1 Pro"
    cat > /tmp/ai-selector-state.json <<JSON
{
  "model": "google/gemini-3.1-pro-preview",
  "prompt": "$PROMPT",
  "cost": "$GEMINI_TOTAL",
  "selected_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
JSON
    echo "💾 Saved to /tmp/ai-selector-state.json"
    ;;
  *)
    echo "❌ Invalid selection. Aborted."
    exit 1
    ;;
esac

echo ""
echo "📌 To use the selected model:"
echo "   /model $(jq -r .model /tmp/ai-selector-state.json)"
echo "   Then paste your prompt or send it as a new message."

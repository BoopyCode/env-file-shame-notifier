#!/bin/bash
# .env Shame Bell - Because apparently .gitignore is just a suggestion
# Rings a bell when you try to commit sensitive .env files
# It's like a dunce cap, but for your terminal

# Configuration - because we know you'll ignore this too
BELL_CHAR="\a"  # ASCII bell - the sound of shame
SHAME_COUNT=0    # How many times you've been shamed today
MAX_SHAME=3     # After this, we assume you're doing it on purpose

# Check if we're in a git repo (you probably are, but let's check)
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Not in a git repo. Can't shame you here."
    exit 0
fi

# Look for .env files in staged changes (the crime scene)
ENV_FILES=$(git diff --cached --name-only | grep -E '\.env$|\.env\.')

if [ -n "$ENV_FILES" ]; then
    # Ding ding! Shame bell!
    echo -e "${BELL_CHAR}"
    echo "🔔 SHAME BELL RINGS LOUDLY 🔔"
    echo "You're trying to commit .env files. Again."
    echo "Files caught red-handed:"
    echo "$ENV_FILES"
    echo ""
    
    SHAME_COUNT=$((SHAME_COUNT + 1))
    
    # Different levels of shame based on how many times you've done this
    if [ $SHAME_COUNT -eq 1 ]; then
        echo "First offense. We'll assume it's an accident."
        echo "(But we're keeping score)"
    elif [ $SHAME_COUNT -eq 2 ]; then
        echo "Second time? Maybe read .gitignore? Just a thought."
    elif [ $SHAME_COUNT -ge $MAX_SHAME ]; then
        echo "${SHAME_COUNT} times?! At this point, you're either"
        echo "1) Testing this script (thank you!)"
        echo "2) Actually trying to leak credentials (please stop)"
        echo "3) A glutton for shame (ding ding ding!)"
    fi
    
    echo ""
    echo "Pro tip: git reset HEAD <file> to unstage the shame"
    echo ""
    
    # Ask if they want to proceed anyway (some people like pain)
    read -p "Commit anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Wise choice. The bell has spoken."
        exit 1
    else
        echo "Proceeding with shame. The bell judges you."
    fi
fi

# If we get here, either no .env files or user chose shame
# Let the commit proceed (with or without judgment)
exit 0

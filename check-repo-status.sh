#!/bin/bash

echo "🔍 2025-Plans Repository Status Check"
echo "===================================="

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ Error: Not in the project directory"
    echo "   Current directory: $(pwd)"
    exit 1
fi

echo "✅ Project directory found: $(pwd)"

# Check Git status
echo ""
echo "📁 Git Repository Status:"
if [ -d ".git" ]; then
    echo "✅ Git repository initialized"
    echo "📊 Git status:"
    git status --short
    echo ""
    echo "🌿 Current branch:"
    git branch
    echo ""
    echo "🔗 Remote repositories:"
    git remote -v
else
    echo "❌ Git repository not initialized"
    echo "💡 Run: git init"
fi

echo ""
echo "📋 Project Files Status:"
echo "========================"

# Check key files
files=("index.html" "README.md" "LICENSE" ".gitignore" "App Info/README.md")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (missing)"
    fi
done

echo ""
echo "📁 Directory Structure:"
echo "======================"
echo "App Info/ - $(find App\ Info/ -name "*.md" | wc -l | tr -d ' ') markdown files"
echo "Templates/ - $(find App\ Info/00-Templates/ -name "*.md" 2>/dev/null | wc -l | tr -d ' ') template files"
echo "Architecture/ - $(find App\ Info/01-Architecture/ -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"
echo "Implementation/ - $(find App\ Info/02-Implementation/ -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"
echo "Quality/ - $(find App\ Info/03-Quality/ -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"
echo "Operations/ - $(find App\ Info/04-Operations/ -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"
echo "Advanced/ - $(find App\ Info/05-Advanced/ -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"
echo "Reference/ - $(find App\ Info/06-Reference/ -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"

echo ""
echo "🎯 Ready for GitHub?"
if [ -d ".git" ] && [ -f "index.html" ] && [ -f "README.md" ]; then
    echo "✅ Yes! Ready to push to GitHub"
    echo ""
    echo "📋 Next steps:"
    echo "1. Create repository on GitHub: https://github.com/new"
    echo "2. Repository name: 2025-plans"
    echo "3. Make it public"
    echo "4. Run: git remote add origin https://github.com/zahraah-dev/2025-plans.git"
    echo "5. Run: git push -u origin main"
else
    echo "❌ Not ready. Missing required files or Git not initialized"
fi

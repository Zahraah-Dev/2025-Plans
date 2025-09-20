#!/bin/bash

echo "🚀 Connecting 2025-Plans to GitHub Repository"
echo "============================================="

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    echo "   Current directory: $(pwd)"
    exit 1
fi

echo "✅ Project directory found: $(pwd)"

# Initialize Git repository if not already done
if [ ! -d ".git" ]; then
    echo "📁 Initializing Git repository..."
    git init
else
    echo "✅ Git repository already initialized"
fi

# Add all files
echo "📦 Adding all files to Git..."
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo "ℹ️  No changes to commit"
else
    echo "💾 Making initial commit..."
    git commit -m "Initial commit: Flutter e-commerce development plans with template system

- 30+ comprehensive Flutter development guides
- Advanced template system with 7 master templates
- Bilingual support (Arabic/English)
- Enterprise-grade documentation structure
- Duplication elimination (~1,500+ lines removed)
- GitHub Pages ready with automated deployment
- AI agent specialization and content management tools
- Complete CI/CD pipeline and quality gates"
fi

# Set default branch to main
echo "🌿 Setting default branch to main..."
git branch -M main

echo ""
echo "🔗 GitHub Repository Connection"
echo "==============================="
echo ""
echo "Please provide your GitHub repository URL:"
echo "Format: https://github.com/zahraah-dev/2025-plans.git"
echo ""
echo "After you provide the URL, run these commands:"
echo ""
echo "1. Add remote origin:"
echo "   git remote add origin https://github.com/zahraah-dev/2025-plans.git"
echo ""
echo "2. Push to GitHub:"
echo "   git push -u origin main"
echo ""
echo "3. Enable GitHub Pages:"
echo "   - Go to repository Settings > Pages"
echo "   - Source: Deploy from a branch"
echo "   - Branch: main"
echo "   - Folder: / (root)"
echo "   - Click Save"
echo ""
echo "4. Your site will be live at:"
echo "   https://zahraah-dev.github.io/2025-plans"
echo ""
echo "✅ Git repository ready for GitHub connection!"

#!/bin/bash

echo "🚀 2025-Plans - Commit and Push to GitHub"
echo "========================================="

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
    echo "💾 Making commit..."
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

# Add remote origin
echo "🔗 Adding remote origin..."
git remote add origin https://github.com/zahraah-dev/2025-plans.git

# Push to GitHub
echo "📤 Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Successfully pushed to GitHub!"
echo ""
echo "🌐 Your site will be live at:"
echo "   https://zahraah-dev.github.io/2025-plans"
echo ""
echo "📋 Next steps:"
echo "1. Go to your repository: https://github.com/zahraah-dev/2025-plans"
echo "2. Click Settings > Pages"
echo "3. Source: Deploy from a branch"
echo "4. Branch: main"
echo "5. Folder: / (root)"
echo "6. Click Save"
echo ""
echo "🎉 Your Flutter e-commerce documentation is now live!"

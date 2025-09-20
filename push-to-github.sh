#!/bin/bash

# 2025 Plans - Push to GitHub Script
# This script will initialize Git, create the repository, and push to GitHub

echo "🚀 2025 Plans - GitHub Repository Setup & Push"
echo "=============================================="

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ Error: index.html not found. Please run this script from the project root directory."
    exit 1
fi

echo "✅ Found project files. Starting Git setup..."

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
echo "🎯 Next Steps:"
echo "=============="
echo ""
echo "1. Create a new repository on GitHub:"
echo "   👉 Go to: https://github.com/new"
echo "   📝 Repository name: 2025-plans"
echo "   📝 Description: Flutter E-commerce Development Plans & Guides"
echo "   🌍 Make it PUBLIC"
echo "   ❌ Don't initialize with README (we already have one)"
echo "   ✅ Click 'Create repository'"
echo ""
echo "2. After creating the repository, run this command:"
echo "   git remote add origin https://github.com/zahraah-dev/2025-plans.git"
echo "   git push -u origin main"
echo ""
echo "3. Enable GitHub Pages:"
echo "   👉 Go to repository Settings > Pages"
echo "   📂 Source: Deploy from a branch"
echo "   🌿 Branch: main"
echo "   📁 Folder: / (root)"
echo "   ✅ Click Save"
echo ""
echo "4. Your site will be live at:"
echo "   🌐 https://zahraah-dev.github.io/2025-plans"
echo ""
echo "📋 Repository Structure Ready:"
echo "============================="
echo "✅ .gitignore - Git ignore rules"
echo "✅ README.md - Repository documentation"
echo "✅ LICENSE - MIT License"
echo "✅ index.html - GitHub Pages home page"
echo "✅ .github/workflows/github-pages.yml - Automated deployment"
echo "✅ App Info/ - 30+ Flutter development guides"
echo "✅ Template system - 7 master templates"
echo "✅ Bilingual support - Arabic and English"
echo ""
echo "🎉 Ready to push to GitHub!"
echo ""
echo "💡 Pro tip: You can also use GitHub CLI if you have it installed:"
echo "   gh repo create 2025-plans --public --description 'Flutter E-commerce Development Plans & Guides'"
echo "   git push -u origin main"

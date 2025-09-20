#!/bin/bash

# 2025 Plans - GitHub Repository Setup Script
# This script helps set up the GitHub repository for GitHub Pages

echo "🚀 Setting up 2025 Plans GitHub Repository..."

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📁 Initializing Git repository..."
    git init
fi

# Add all files
echo "📦 Adding files to Git..."
git add .

# Make initial commit
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

# Set default branch to main
echo "🌿 Setting default branch to main..."
git branch -M main

echo "✅ Git repository setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Create a new repository on GitHub:"
echo "   - Go to https://github.com/new"
echo "   - Repository name: 2025-plans"
echo "   - Description: Flutter E-commerce Development Plans & Guides"
echo "   - Make it public"
echo "   - Don't initialize with README (we already have one)"
echo ""
echo "2. Add the remote origin:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/2025-plans.git"
echo ""
echo "3. Push to GitHub:"
echo "   git push -u origin main"
echo ""
echo "4. Enable GitHub Pages:"
echo "   - Go to repository Settings > Pages"
echo "   - Source: Deploy from a branch"
echo "   - Branch: main"
echo "   - Folder: / (root)"
echo "   - Save"
echo ""
echo "5. Your site will be available at:"
echo "   https://YOUR_USERNAME.github.io/2025-plans"
echo ""
echo "🎉 Setup complete! Your Flutter e-commerce documentation will be live on GitHub Pages!"

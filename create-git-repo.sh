#!/bin/bash

echo "🚀 Creating Git Repository for 2025 Plans"
echo "========================================="

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    echo "   Current directory: $(pwd)"
    echo "   Expected files: index.html, README.md, etc."
    exit 1
fi

echo "✅ Found project files in: $(pwd)"

# Initialize Git repository
echo "📁 Initializing Git repository..."
git init

# Add all files
echo "📦 Adding all files to Git..."
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

echo ""
echo "✅ Git repository created successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Create repository on GitHub: https://github.com/new"
echo "2. Repository name: 2025-plans"
echo "3. Make it public"
echo "4. Don't initialize with README"
echo "5. Run: git remote add origin https://github.com/YOUR_USERNAME/2025-plans.git"
echo "6. Run: git push -u origin main"
echo ""
echo "🎉 Ready to push to GitHub!"

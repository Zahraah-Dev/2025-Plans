// 2025 Plans - Flutter E-commerce Documentation JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize the documentation site
    initializeDocumentation();
});

function initializeDocumentation() {
    // Add smooth scrolling for anchor links
    addSmoothScrolling();
    
    // Add copy code functionality
    addCopyCodeButtons();
    
    // Add table of contents generation
    generateTableOfContents();
    
    // Add search functionality
    initializeSearch();
    
    // Add mobile menu toggle
    initializeMobileMenu();
}

function addSmoothScrolling() {
    // Add smooth scrolling to all anchor links
    const anchorLinks = document.querySelectorAll('a[href^="#"]');
    anchorLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

function addCopyCodeButtons() {
    // Add copy buttons to code blocks
    const codeBlocks = document.querySelectorAll('pre code');
    codeBlocks.forEach(block => {
        const pre = block.parentElement;
        if (pre && !pre.querySelector('.copy-button')) {
            const copyButton = document.createElement('button');
            copyButton.className = 'copy-button';
            copyButton.textContent = 'Copy';
            copyButton.addEventListener('click', function() {
                navigator.clipboard.writeText(block.textContent).then(() => {
                    copyButton.textContent = 'Copied!';
                    setTimeout(() => {
                        copyButton.textContent = 'Copy';
                    }, 2000);
                });
            });
            
            pre.style.position = 'relative';
            pre.appendChild(copyButton);
        }
    });
}

function generateTableOfContents() {
    // Generate table of contents from headings
    const content = document.querySelector('.content');
    if (!content) return;
    
    const headings = content.querySelectorAll('h2, h3, h4');
    if (headings.length === 0) return;
    
    const toc = document.createElement('div');
    toc.className = 'table-of-contents';
    toc.innerHTML = '<h3>Table of Contents</h3><ul></ul>';
    
    const tocList = toc.querySelector('ul');
    
    headings.forEach((heading, index) => {
        const id = `heading-${index}`;
        heading.id = id;
        
        const li = document.createElement('li');
        li.className = `toc-${heading.tagName.toLowerCase()}`;
        
        const a = document.createElement('a');
        a.href = `#${id}`;
        a.textContent = heading.textContent;
        
        li.appendChild(a);
        tocList.appendChild(li);
    });
    
    // Insert TOC after the first heading
    const firstHeading = content.querySelector('h1, h2');
    if (firstHeading) {
        firstHeading.parentNode.insertBefore(toc, firstHeading.nextSibling);
    }
}

function initializeSearch() {
    // Simple search functionality
    const searchInput = document.createElement('input');
    searchInput.type = 'text';
    searchInput.placeholder = 'Search documentation...';
    searchInput.className = 'search-input';
    
    const searchResults = document.createElement('div');
    searchResults.className = 'search-results';
    
    // Add search to navigation
    const nav = document.querySelector('.nav-container');
    if (nav) {
        nav.appendChild(searchInput);
        nav.appendChild(searchResults);
    }
    
    searchInput.addEventListener('input', function() {
        const query = this.value.toLowerCase();
        if (query.length < 2) {
            searchResults.innerHTML = '';
            return;
        }
        
        // Simple search through content
        const content = document.querySelector('.content');
        if (!content) return;
        
        const headings = content.querySelectorAll('h2, h3, h4, p');
        const results = [];
        
        headings.forEach(heading => {
            if (heading.textContent.toLowerCase().includes(query)) {
                results.push({
                    text: heading.textContent,
                    element: heading
                });
            }
        });
        
        displaySearchResults(results, searchResults);
    });
}

function displaySearchResults(results, container) {
    if (results.length === 0) {
        container.innerHTML = '<p>No results found</p>';
        return;
    }
    
    const html = results.slice(0, 5).map(result => {
        return `<div class="search-result">
            <a href="#${result.element.id || '#'}">${result.text}</a>
        </div>`;
    }).join('');
    
    container.innerHTML = html;
}

function initializeMobileMenu() {
    // Add mobile menu toggle
    const nav = document.querySelector('.nav-menu');
    if (!nav) return;
    
    const toggleButton = document.createElement('button');
    toggleButton.className = 'mobile-menu-toggle';
    toggleButton.innerHTML = '☰';
    
    const navContainer = document.querySelector('.nav-container');
    if (navContainer) {
        navContainer.insertBefore(toggleButton, nav);
    }
    
    toggleButton.addEventListener('click', function() {
        nav.classList.toggle('mobile-open');
    });
}

// Add CSS for the JavaScript features
const style = document.createElement('style');
style.textContent = `
    .copy-button {
        position: absolute;
        top: 10px;
        right: 10px;
        background: var(--primary-color);
        color: white;
        border: none;
        padding: 5px 10px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 12px;
    }
    
    .table-of-contents {
        background: var(--bg-light);
        padding: 1rem;
        border-radius: 8px;
        margin: 1rem 0;
        border-left: 4px solid var(--accent-color);
    }
    
    .table-of-contents ul {
        list-style: none;
        padding: 0;
    }
    
    .table-of-contents li {
        margin: 0.5rem 0;
    }
    
    .table-of-contents a {
        color: var(--primary-color);
        text-decoration: none;
    }
    
    .table-of-contents a:hover {
        text-decoration: underline;
    }
    
    .search-input {
        padding: 0.5rem;
        border: 1px solid var(--border-color);
        border-radius: 4px;
        margin-left: 1rem;
    }
    
    .search-results {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: white;
        border: 1px solid var(--border-color);
        border-radius: 4px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        z-index: 1000;
        display: none;
    }
    
    .search-result {
        padding: 0.5rem;
        border-bottom: 1px solid var(--border-color);
    }
    
    .search-result a {
        color: var(--text-color);
        text-decoration: none;
    }
    
    .search-result a:hover {
        background: var(--bg-light);
    }
    
    .mobile-menu-toggle {
        display: none;
        background: none;
        border: none;
        font-size: 1.5rem;
        cursor: pointer;
        color: white;
    }
    
    @media (max-width: 768px) {
        .mobile-menu-toggle {
            display: block;
        }
        
        .nav-menu {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: var(--primary-color);
            flex-direction: column;
            padding: 1rem;
        }
        
        .nav-menu.mobile-open {
            display: flex;
        }
    }
`;
document.head.appendChild(style);

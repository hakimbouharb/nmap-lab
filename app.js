document.addEventListener('DOMContentLoaded', () => {
    const sidebar = document.querySelector('.sidebar');
    const mainContent = document.getElementById('mainContent');

    // Dynamically populate the sidebar
    const sections = {};
    modules.forEach(module => {
        if (!sections[module.section]) {
            sections[module.section] = [];
        }
        sections[module.section].push(module);
    });

    for (const section in sections) {
        const sectionDiv = document.createElement('div');
        sectionDiv.className = 'sidebar-section';

        const titleDiv = document.createElement('div');
        titleDiv.className = 'section-title';
        titleDiv.textContent = section;
        sectionDiv.appendChild(titleDiv);

        sections[section].forEach(module => {
            const moduleItem = document.createElement('div');
            moduleItem.className = 'module-item';
            moduleItem.setAttribute('data-module', module.id);
            moduleItem.onclick = () => loadModule(module.id);
            moduleItem.innerHTML = `
                <span class="module-text">
                    <span class="module-icon">${module.icon}</span>
                    ${module.title}
                </span>
                <span class="check-icon">✓</span>
            `;
            sectionDiv.appendChild(moduleItem);
        });

        sidebar.appendChild(sectionDiv);
    }


    // Load the welcome module by default
    loadModule('welcome');
});

function loadModule(moduleName) {
    const mainContent = document.getElementById('mainContent');
    const modulePath = `modules/${moduleName}.html`;

    // Highlight the active module in the sidebar
    const moduleItems = document.querySelectorAll('.module-item');
    moduleItems.forEach(item => {
        item.classList.remove('active');
        if (item.getAttribute('data-module') === moduleName) {
            item.classList.add('active');
        }
    });

    // Fetch and display the module content
    fetch(modulePath)
        .then(response => response.text())
        .then(data => {
            mainContent.innerHTML = data;
        })
        .catch(error => {
            console.error('Error loading module:', error);
            mainContent.innerHTML = '<p>Error loading content. Please try again later.</p>';
        });
}

function logout() {
    // Placeholder for logout functionality
    console.log('Logout button clicked');
    // Redirect to login page, for example
    // window.location.href = 'index.html';
}

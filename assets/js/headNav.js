document.addEventListener('DOMContentLoaded', function () {
    var headNav = document.getElementById('header-nav');
    if (headNav) {
        var content = `
                            <ul class="navbar-nav">
                                <li class="dropdown"> 
                                    <a class="dropdown-toggle"><i class="fa-brands fa-r-project"></i><i class="arrow"></i></a>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="https://genai.gd.edu.kg/r/">Overview</a></li>
                                        <li><a class="dropdown-item" href="https://genai.gd.edu.kg/r/documentation/">Documentation</a></li>
                                    </ul>
                                </li>
                                <li class="dropdown"> 
                                    <a class="dropdown-toggle"><i class="fa-brands fa-python"></i><i class="arrow"></i></a>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="">Overview</a></li>
                                        <li><a class="dropdown-item" href="">Documentation</a></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="https://github.com/GitData-GA/GenAI/tree/main/" target="_blank"><i class="fa-brands fa-github"></i></a>
                                </li>
                            </ul>
        `;
        headNav.innerHTML = content;
    } else {
        console.error('Container not found. Make sure the div with id "header-nav" exists.');
    }
});

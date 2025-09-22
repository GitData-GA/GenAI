// --- Element Selection ---
const themeToggle = document.getElementById('theme-toggle');
const body = document.body;
const chatContainer = document.getElementById('chat-container');
const chatMessages = document.getElementById('chat-messages');
const messageInput = document.getElementById('message-input');
const sendButton = document.getElementById('send-button');
const uploadImageButton = document.getElementById('upload-image-button');
const imageUploadInput = document.getElementById('image-upload-input');
const imagePreviewContainer = document.getElementById('image-preview-container');
const imageModal = document.getElementById('image-modal');
const modalImage = document.getElementById('modal-image');
const modalCloseButton = document.getElementById('modal-close-button');
const enlargeButton = document.getElementById('enlarge-button');
const enlargeIcon = enlargeButton.querySelector('.enlarge-icon');
const shrinkIcon = enlargeButton.querySelector('.shrink-icon');
const apiKeyModal = document.getElementById('api-key-modal');
const apiKeyInput = document.getElementById('api-key-input');
const apiKeyError = document.getElementById('api-key-error');
const saveApiKeyButton = document.getElementById('save-api-key-button');
const mainContent = document.getElementById('main-content');
const logoBanner = document.getElementById('logo-banner');
const proxyContainer = document.getElementById('proxy-container');
const proxyToggle = document.getElementById('proxy-toggle');
const termsAgreeCheckbox = document.getElementById('terms-agree');
const loadingVerifier = document.getElementById('loading-verifier');

// Sidebar Elements
const appContainer = document.getElementById('app-container');
const sidebar = document.getElementById('sidebar');
const sidebarToggleOpen = document.getElementById('sidebar-toggle-open');
const sidebarToggleClose = document.getElementById('sidebar-toggle-close');
const sidebarOverlay = document.getElementById('sidebar-overlay');
const modelSelect = document.getElementById('model-select');
const newChatButton = document.getElementById('new-chat-button');
const importChatButton = document.getElementById('import-chat-button');
const importChatInput = document.getElementById('import-chat-input');
const clearStorageButton = document.getElementById('clear-storage-button');
const conversationHistoryContainer = document.getElementById('conversation-history');
const userCountrySpan = document.getElementById('user-country');
const proxyStatusFooter = document.getElementById('proxy-status-footer');

// --- Global State ---
let uploadedImagesData = [];
let chatHistory = [];
let conversations = {};
let currentChatId = null;
let geminiApiKey = '';
let geminiModel = 'gemini-2.5-flash-lite';
let currentlyEditingIndex = null;
const GOOGLE_API_BASE = 'https://generativelanguage.googleapis.com/';
const PROXY_API_BASE = 'https://api.genai.gd.edu.kg/google/';

// --- Helper Functions ---

async function loadModelOptions() {
    try {
        const response = await fetch('https://genai.gd.edu.kg/lab/model.json');
        if (!response.ok) throw new Error('Failed to load model options');
        const models = await response.json();

        modelSelect.innerHTML = ''; // Clear existing options

        if (models.google) {
            for (const modelKey in models.google) {
                const option = document.createElement('option');
                option.value = modelKey;
                option.textContent = models.google[modelKey];
                modelSelect.appendChild(option);
            }
        } else {
            throw new Error("Google models not found in the provided JSON.");
        }

        const savedModel = localStorage.getItem('geminiModel');
        if (savedModel && modelSelect.querySelector(`option[value="${savedModel}"]`)) {
            modelSelect.value = savedModel;
        } else if (modelSelect.options.length > 0) {
            modelSelect.selectedIndex = 0;
        }
        geminiModel = modelSelect.value;
        localStorage.setItem('geminiModel', geminiModel);

    } catch (error) {
        console.error('Error loading model options:', error);
        modelSelect.innerHTML = '<option value="gemini-2.5-flash-lite">Gemini 2.5 Flash Lite (Default)</option>';
        geminiModel = 'gemini-2.5-flash-lite';
    }
}

async function fetchUserCountryName() {
    try {
        const res = await fetch("https://genai.gd.edu.kg/cdn-cgi/trace", {
            cache: "no-store"
        });
        if (!res.ok) throw new Error(`Trace endpoint returned ${res.status}`);
        const txt = await res.text();
        const map = Object.fromEntries(txt.trim().split(/\s+/).map(p => p.split("=")));
        const code = map.loc?.toUpperCase();
        if (!code) return "Unknown";
        if (typeof Intl?.DisplayNames === "function") {
            try {
                const enNames = new Intl.DisplayNames(["zh-CN"], {
                    type: "region"
                });
                return enNames.of(code) || code;
            } catch {
                return code;
            }
        }
        return code;
    } catch (err) {
        console.error("Could not detect country:", err);
        return "Unknown";
    }
}

const updateProxyStatusFooter = () => {
    if (proxyToggle.checked) {
        proxyStatusFooter.innerHTML = `使用公共代理。请查看<a href="https://genai.gd.edu.kg/api/" target="_blank" class="text-blue-500 hover:underline">风险和条款</a>。`;
    } else {
        proxyStatusFooter.innerHTML = '';
    }
};

const copyToClipboard = (text, button) => {
    navigator.clipboard.writeText(text).then(() => {
        const originalIcon = button.innerHTML;
        button.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" /></svg>`;
        setTimeout(() => {
            button.innerHTML = originalIcon;
        }, 2000);
    }).catch(err => {
        console.error('Failed to copy text: ', err);
        const textArea = document.createElement("textarea");
        textArea.value = text;
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        try {
            document.execCommand('copy');
            const originalIcon = button.innerHTML;
            button.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" /></svg>`;
            setTimeout(() => {
                button.innerHTML = originalIcon;
            }, 2000);
        } catch (err) {
            console.error('Fallback copy failed: ', err);
        }
        document.body.removeChild(textArea);
    });
};

const cancelEdit = () => {
    if (currentlyEditingIndex !== null) {
        currentlyEditingIndex = null;
        renderChatMessages(); // Re-render to remove the edit UI
    }
};

const handleEditMessage = (messageIndex) => {
    if (currentlyEditingIndex !== null) {
        cancelEdit();
    }
    if (messageIndex === undefined || chatHistory[messageIndex]?.role !== 'user') return;

    currentlyEditingIndex = messageIndex;

    const messageElement = chatMessages.querySelector(`[data-message-index='${messageIndex}']`);
    if (!messageElement) return;

    const bubble = messageElement.querySelector('.message-bubble');
    const originalContent = bubble.querySelector('p');
    const originalImages = bubble.querySelector('.flex-wrap');
    const originalActions = bubble.querySelector('.message-actions');

    const textToEdit = chatHistory[messageIndex].parts.find(p => p.text)?.text || '';

    if (originalContent) originalContent.style.display = 'none';
    if (originalImages) originalImages.style.display = 'none';
    if (originalActions) originalActions.style.display = 'none';

    const editContainer = document.createElement('div');
    editContainer.className = 'edit-container';

    const editTextarea = document.createElement('textarea');
    editTextarea.className = 'edit-textarea';
    editTextarea.value = textToEdit;

    const editActions = document.createElement('div');
    editActions.className = 'edit-actions';
    editActions.innerHTML = `
        <button class="cancel-edit-btn">取消</button>
        <button class="save-edit-btn" data-index="${messageIndex}">保存 & 提交</button>
    `;

    editContainer.appendChild(editTextarea);
    editContainer.appendChild(editActions);
    bubble.appendChild(editContainer);

    editTextarea.focus();
    editTextarea.style.height = 'auto';
    editTextarea.style.height = `${editTextarea.scrollHeight}px`;
    editTextarea.addEventListener('input', () => {
        editTextarea.style.height = 'auto';
        editTextarea.style.height = `${editTextarea.scrollHeight}px`;
    });
};

const confirmEdit = async (messageIndex) => {
    const messageElement = chatMessages.querySelector(`[data-message-index='${messageIndex}']`);
    if (!messageElement) return;

    const editTextarea = messageElement.querySelector('.edit-textarea');
    if (!editTextarea) return;

    const newText = editTextarea.value.trim();
    const originalMessage = chatHistory[messageIndex];

    let textPart = originalMessage.parts.find(p => p.text);
    if (textPart) {
        textPart.text = newText;
    } else {
        originalMessage.parts.unshift({
            text: newText
        });
    }

    chatHistory.splice(messageIndex + 1);

    if (currentChatId) {
        conversations[currentChatId] = chatHistory;
        saveConversationsToStorage();
    }

    currentlyEditingIndex = null;
    renderChatMessages();

    const textForApi = newText;
    const imagesForApi = originalMessage.parts
        .filter(p => p.inlineData)
        .map(p => `data:${p.inlineData.mimeType};base64,${p.inlineData.data}`);

    await callGeminiApi(textForApi, imagesForApi);
};

// --- Conversation Management ---
const saveConversationsToStorage = () => {
    const nonEmptyConversations = Object.fromEntries(
        Object.entries(conversations).filter(([, history]) => history.length > 0)
    );
    localStorage.setItem('geminiConversations', JSON.stringify(nonEmptyConversations));
};

const loadConversationsFromStorage = () => {
    const stored = localStorage.getItem('geminiConversations');
    return stored ? JSON.parse(stored) : {};
};

const renderConversationHistory = () => {
    if (!geminiApiKey) {
        conversationHistoryContainer.innerHTML = '';
        return;
    }
    conversationHistoryContainer.innerHTML = '';
    const sortedIds = Object.keys(conversations).sort((a, b) => b - a);

    if (sortedIds.length === 0 && (chatHistory.length === 0 || !currentChatId)) {
        conversationHistoryContainer.innerHTML = '<p class="text-sm text-center text-gray-500 dark:text-gray-400">尚无聊天记录。</p>';
        return;
    }

    const displayedIds = new Set(sortedIds);
    if (currentChatId && !displayedIds.has(currentChatId) && chatHistory.length > 0) {
        sortedIds.unshift(currentChatId);
    }

    sortedIds.forEach(id => {
        if (!conversations[id] && id !== currentChatId) return;
        if (conversations[id] && conversations[id].length === 0 && id !== currentChatId) return;

        const historyItem = document.createElement('div');
        const title = new Date(parseInt(id)).toLocaleString();

        historyItem.className = `conversation-item flex items-center justify-between p-2 rounded-md cursor-pointer ${id === currentChatId ? 'active' : ''}`;
        historyItem.dataset.id = id;

        historyItem.innerHTML = `
            <span class="truncate text-sm flex-1">${title}</span>
            <div class="flex items-center ml-2">
                <button class="download-chat-btn p-1 rounded-md hover:bg-gray-300 dark:hover:bg-gray-600" data-id="${id}">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" /></svg>
                </button>
                <button class="delete-chat-btn p-1 rounded-md hover:bg-red-500 hover:text-white" data-id="${id}">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                </button>
            </div>
        `;
        conversationHistoryContainer.appendChild(historyItem);
    });
};

const startNewChat = () => {
    if (chatHistory.length === 0 && currentChatId) return;
    if (currentChatId && chatHistory.length > 0) {
        conversations[currentChatId] = chatHistory;
        saveConversationsToStorage();
    }
    currentChatId = Date.now().toString();
    chatHistory = [];
    renderConversationHistory();
    renderChatMessages();
    messageInput.value = '';
    autoResizeTextarea();
    updateSendButtonState();
};

const loadChat = (id) => {
    if (id === currentChatId) return;

    if (currentChatId && chatHistory.length > 0) {
        conversations[currentChatId] = chatHistory;
    } else if (currentChatId) {
        delete conversations[currentChatId];
    }

    currentChatId = id;
    chatHistory = conversations[id] || [];
    saveConversationsToStorage();
    renderConversationHistory();
    renderChatMessages();
};

const deleteChat = (id) => {
    delete conversations[id];

    if (id === currentChatId) {
        const remainingIds = Object.keys(conversations).sort((a, b) => b - a);
        if (remainingIds.length > 0) {
            loadChat(remainingIds[0]);
        } else {
            currentChatId = null;
            chatHistory = [];
            renderChatMessages();
        }
    }
    saveConversationsToStorage();
    renderConversationHistory();
};

const downloadChat = (id) => {
    const historyToDownload = conversations[id] || chatHistory;
    if (!historyToDownload || historyToDownload.length === 0) return;
    const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(historyToDownload, null, 2));
    const downloadAnchorNode = document.createElement('a');
    downloadAnchorNode.setAttribute("href", dataStr);
    downloadAnchorNode.setAttribute("download", `chat-history-${id}.json`);
    document.body.appendChild(downloadAnchorNode);
    downloadAnchorNode.click();
    downloadAnchorNode.remove();
};

const importChat = (event) => {
    const file = event.target.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (e) => {
        try {
            const importedHistory = JSON.parse(e.target.result);
            if (Array.isArray(importedHistory)) {
                startNewChat();
                chatHistory = importedHistory;
                conversations[currentChatId] = chatHistory;
                saveConversationsToStorage();
                renderChatMessages();
                renderConversationHistory();
            } else {
                alert('聊天记录的 JSON 格式无效。');
            }
        } catch (error) {
            alert('无法解析 JSON 文件。');
            console.error(error);
        }
    };
    reader.readAsText(file);
    importChatInput.value = '';
};

// --- API Key & Initialization ---
const verifyApiKey = async (key) => {
    if (!key) return {
        success: false,
        message: 'API 密钥为空。'
    };
    const baseUrl = proxyToggle.checked ? PROXY_API_BASE : GOOGLE_API_BASE;
    const API_URL = `${baseUrl}v1beta/models?key=${key}`;
    try {
        const response = await fetch(API_URL);
        if (response.ok) return {
            success: true
        };

        let errorMessage = `HTTP 错误: ${response.status} ${response.statusText}`;
        try {
            const errorData = await response.json();
            errorMessage = errorData.error?.message || errorMessage;
        } catch (e) {
            // Ignore JSON parsing error, use status text
        }

        if (errorMessage.includes("User location is not supported")) {
            proxyContainer.classList.remove('hidden');
            const countryName = await fetchUserCountryName();
            document.getElementById("show-country").textContent = countryName;
            proxyToggle.addEventListener('change', updateProxyStatusFooter);
        }
        return {
            success: false,
            message: errorMessage
        };
    } catch (error) {
        console.error("Verification fetch error:", error);
        return {
            success: false,
            message: '网络错误或 CORS 问题。请检查控制台。'
        };
    }
};

const handleSuccessfulVerification = (key) => {
    geminiApiKey = key;
    localStorage.setItem('geminiApiKey', key);

    if (proxyToggle.checked) {
        localStorage.setItem('proxyConsent', 'true');
    } else {
        localStorage.setItem('proxyConsent', 'false');
    }

    // Enable sidebar buttons on success
    importChatButton.disabled = false;
    clearStorageButton.disabled = false;

    apiKeyModal.classList.add('hidden');
    mainContent.classList.remove('invisible');
    updateProxyStatusFooter();
    conversations = loadConversationsFromStorage();
    currentChatId = null;
    chatHistory = [];
    renderConversationHistory();
    renderChatMessages();
};

const handleVerificationClick = async () => {
    const key = apiKeyInput.value.trim();
    saveApiKeyButton.disabled = true;
    saveApiKeyButton.textContent = '验证中...';
    apiKeyError.classList.add('hidden');

    let result = await verifyApiKey(key);

    if (!result.success && result.message?.includes("User location is not supported") && localStorage.getItem('proxyConsent') === 'true') {
        proxyToggle.checked = true;
        updateProxyStatusFooter();
        result = await verifyApiKey(key);
    }

    if (result.success) {
        handleSuccessfulVerification(key);
    } else {
        apiKeyError.textContent = `验证失败：${result.message}`;
        apiKeyError.classList.remove('hidden');
    }
    saveApiKeyButton.disabled = !termsAgreeCheckbox.checked;
    saveApiKeyButton.textContent = '开始聊天';
};

document.addEventListener('DOMContentLoaded', async () => {
    await loadModelOptions();
    // Disable buttons initially
    importChatButton.disabled = true;
    clearStorageButton.disabled = true;

    conversationHistoryContainer.innerHTML = '';
    const storedApiKey = localStorage.getItem('geminiApiKey');

    if (storedApiKey) {
        apiKeyModal.classList.add('hidden');
        loadingVerifier.classList.remove('hidden');
        loadingVerifier.classList.add('flex');

        let result = await verifyApiKey(storedApiKey);

        if (!result.success && result.message?.includes("User location is not supported") && localStorage.getItem('proxyConsent') === 'true') {
            proxyToggle.checked = true;
            updateProxyStatusFooter();
            result = await verifyApiKey(storedApiKey);
        }

        loadingVerifier.classList.add('hidden');
        loadingVerifier.classList.remove('flex');

        if (result.success) {
            termsAgreeCheckbox.checked = true;
            saveApiKeyButton.disabled = false;
            handleSuccessfulVerification(storedApiKey);
        } else {
            apiKeyModal.classList.remove('hidden');
            apiKeyError.textContent = `验证失败：${result.message}`;
            apiKeyError.classList.remove('hidden');

            if (result.message?.includes("User location is not supported")) {
                apiKeyInput.value = storedApiKey;
            } else {
                localStorage.removeItem('geminiApiKey');
                apiKeyInput.value = '';
            }
        }
    }

    const country = await fetchUserCountryName();
    userCountrySpan.textContent = country;
    updateProxyStatusFooter();
});

saveApiKeyButton.addEventListener('click', handleVerificationClick);
apiKeyInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && !saveApiKeyButton.disabled) handleVerificationClick();
});
termsAgreeCheckbox.addEventListener('change', () => {
    saveApiKeyButton.disabled = !termsAgreeCheckbox.checked;
});

// --- Theme Toggle Logic ---
const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');
const applyTheme = (theme) => {
    body.classList.remove('light-mode', 'dark-mode');
    body.classList.add(theme + '-mode');
    logoBanner.src = (theme === 'dark') ? 'assets/img/logo/logo-banner-white.svg' : 'assets/img/logo/logo-banner-black.svg';
};
const savedTheme = localStorage.getItem('theme');
if (savedTheme) applyTheme(savedTheme);
else applyTheme(prefersDarkScheme.matches ? 'dark' : 'light');
prefersDarkScheme.addEventListener('change', e => {
    if (!localStorage.getItem('theme')) applyTheme(e.matches ? 'dark' : 'light');
});
themeToggle.addEventListener('click', () => {
    const currentTheme = body.classList.contains('light-mode') ? 'light' : 'dark';
    const newTheme = currentTheme === 'light' ? 'dark' : 'light';
    applyTheme(newTheme);
    localStorage.setItem('theme', newTheme);
});

// --- Chat Functionality ---
const scrollToBottom = () => chatContainer.scrollTop = chatContainer.scrollHeight;
const updateSendButtonState = () => {
    const hasContent = messageInput.value.trim() || uploadedImagesData.length > 0;
    sendButton.disabled = !hasContent;
    sendButton.classList.toggle('opacity-50', !hasContent);
    sendButton.classList.toggle('cursor-not-allowed', !hasContent);
};

const showWelcomeMessage = () => {
    chatMessages.innerHTML = `
        <div class="welcome-container">
            <h1 class="text-xl font-semibold welcome-text">欢迎来到 Google Gemini 专用的 GitData GenAI 实验室！</h1>
            <p class="mt-2 welcome-text">有任何问题都可以随意询问！</p>
        </div>
    `;
    chatMessages.style.height = '100%';
};

const renderChatMessages = () => {
    chatMessages.style.height = 'auto';
    chatMessages.innerHTML = '';

    if (chatHistory.length === 0) {
        showWelcomeMessage();
        return;
    }
    chatHistory.forEach((message, index) => {
        const text = message.parts.find(p => p.text)?.text || '';
        if (message.role === 'user') {
            const images = message.parts.filter(p => p.inlineData).map(p => `data:${p.inlineData.mimeType};base64,${p.inlineData.data}`);
            addUserMessage(text, images, index);
        } else if (message.role === 'model') {
            addBotMessage(text, false, true, index);
        }
    });
};

const addUserMessage = (text, imagesUrlArray = [], messageIndex) => {
    const messageElement = document.createElement('div');
    messageElement.className = 'flex items-start gap-4 mb-6 chat-message user justify-end';
    messageElement.dataset.messageIndex = messageIndex;
    const bubble = document.createElement('div');
    bubble.className = 'group w-full lg:max-w-[75%] p-4 rounded-xl message-bubble relative';
    if (imagesUrlArray && imagesUrlArray.length > 0) {
        const imagesContainer = document.createElement('div');
        imagesContainer.className = 'flex flex-wrap gap-2 mb-2';
        imagesUrlArray.forEach(imageUrl => {
            const img = document.createElement('img');
            img.src = imageUrl;
            img.alt = 'User upload';
            img.className = 'chat-image w-[100px] h-[100px] object-cover rounded-lg cursor-pointer transition-transform hover:scale-105';
            imagesContainer.appendChild(img);
        });
        bubble.appendChild(imagesContainer);
    }
    if (text) {
        const content = document.createElement('p');
        content.className = 'whitespace-pre-wrap';
        content.textContent = text;
        bubble.appendChild(content);
    }

    const actionsContainer = document.createElement('div');
    actionsContainer.className = 'message-actions';
    actionsContainer.innerHTML = `
      <button class="edit-btn p-1 rounded-md" data-index="${messageIndex}" title="Edit">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.5L15.232 5.232z" /></svg>
      </button>
      <button class="copy-btn p-1 rounded-md" data-index="${messageIndex}" title="Copy">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" /></svg>
      </button>
  `;
    bubble.appendChild(actionsContainer);

    messageElement.appendChild(bubble);
    chatMessages.appendChild(messageElement);
    scrollToBottom();
};

const showTypingIndicator = () => {
    const typingElement = document.createElement('div');
    typingElement.id = 'typing-indicator';
    typingElement.className = 'flex items-start gap-4 mb-6 chat-message bot';
    typingElement.innerHTML = `<div class="flex-shrink-0"><img src="https://static.gd.edu.kg/images/logo.svg" alt="Bot" width="32px" /></div><div class="flex-1 p-4 rounded-xl message-bubble flex items-center"><div class="typing-indicator">思考中 <span></span><span></span><span></span></div></div>`;
    chatMessages.appendChild(typingElement);
    scrollToBottom();
};

const hideTypingIndicator = () => {
    const indicator = document.getElementById('typing-indicator');
    if (indicator) indicator.remove();
};

const renderContent = (element, content) => {
    const parts = content.split(/(```[\s\S]*?```|`[^`]*?`)/g);
    const processedContent = parts.map((part, index) => {
        if (index % 2 === 1) return part;
        return part.replace(/\\\(/g, '\\\\(').replace(/\\\)/g, '\\\\)').replace(/\\\[/g, '\\\\[').replace(/\\\]/g, '\\\\]');
    }).join('');
    element.innerHTML = marked.parse(processedContent);
    if (window.MathJax) {
        window.MathJax.typesetPromise([element]).catch((err) => console.log('MathJax typesetting error:', err));
    }
};

const addBotMessage = (content, isStreaming, isComplete, messageIndex) => {
    const messageElement = document.createElement('div');
    messageElement.className = 'flex items-start gap-4 mb-6 chat-message bot';
    messageElement.dataset.messageIndex = messageIndex;
    const bubble = document.createElement('div');
    bubble.className = 'group flex-1 p-4 rounded-xl message-bubble relative';
    const responseContainer = document.createElement('div');
    responseContainer.className = 'bot-response-content mt-1';

    if (isStreaming) bubble.classList.add('streaming');

    if (isComplete) {
        renderContent(responseContainer, content);
        const actionsContainer = document.createElement('div');
        actionsContainer.className = 'message-actions';
        actionsContainer.innerHTML = `
            <button class="copy-btn p-1 rounded-md" data-index="${messageIndex}" title="Copy">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" /></svg>
            </button>
        `;
        bubble.appendChild(actionsContainer);
    } else {
        responseContainer.textContent = content;
    }

    bubble.prepend(responseContainer);
    messageElement.innerHTML = `<div class="flex-shrink-0"><img src="https://static.gd.edu.kg/images/logo.svg" alt="Bot" width="32px" /></div>`;
    messageElement.appendChild(bubble);
    chatMessages.appendChild(messageElement);
    scrollToBottom();
    return responseContainer;
};

const callGeminiApi = async (text, images) => {
    showTypingIndicator();

    const baseUrl = proxyToggle.checked ? PROXY_API_BASE : GOOGLE_API_BASE;
    const API_URL = `${baseUrl}v1beta/models/${geminiModel}:streamGenerateContent?key=${geminiApiKey}`;

    const payload = {
        system_instruction: {
          parts: [
            {
              text: "您是一位友善且乐于助人的助手。请确保您的答案完整，除非用户要求更简洁的表达方式。生成代码时，请根据需要对代码段进行解释，并保持良好的编码习惯。当用户提出信息咨询时，请提供能够反映您对该领域深刻理解的答案，并保证其正确性。对于任何非中文的查询，除非用户另有说明，否则请使用与提示相同的语言进行回复。对于涉及推理的提示，请在提供最终答案之前，清晰地解释推理过程的每个步骤。"
            }
          ]
        },
        contents: chatHistory
    };

    let responseContentContainer;
    let accumulatedResponse = '';

    try {
        const response = await fetch(API_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        });
        hideTypingIndicator();
        if (!response.ok) {
            const errorBody = await response.json();
            throw new Error(`API Error: ${response.status} ${errorBody[0].error?.message || "Unknown error"}`);
        }
        responseContentContainer = addBotMessage('', true, false);
        const bubble = responseContentContainer.parentElement;
        const reader = response.body.getReader();
        const decoder = new TextDecoder();
        let buffer = '';
        while (true) {
            const {
                done,
                value
            } = await reader.read();
            if (done) {
                bubble.classList.remove('streaming');
                renderContent(responseContentContainer, accumulatedResponse);

                const modelMessageIndex = chatHistory.length;
                const actionsContainer = document.createElement('div');
                actionsContainer.className = 'message-actions';
                actionsContainer.innerHTML = `
                <button class="copy-btn p-1 rounded-md" data-index="${modelMessageIndex}" title="Copy">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" /></svg>
                </button>
            `;
                bubble.appendChild(actionsContainer);

                chatHistory.push({
                    role: "model",
                    parts: [{
                        text: accumulatedResponse
                    }]
                });
                conversations[currentChatId] = chatHistory;
                saveConversationsToStorage();
                renderConversationHistory();
                break;
            }
            buffer += decoder.decode(value, {
                stream: true
            });
            let lastParsedIndex = 0;
            while (true) {
                const start = buffer.indexOf('{', lastParsedIndex);
                if (start === -1) break;
                let braceCount = 0;
                let end = -1;
                for (let i = start; i < buffer.length; i++) {
                    if (buffer[i] === '{') braceCount++;
                    else if (buffer[i] === '}') braceCount--;
                    if (braceCount === 0) {
                        end = i;
                        break;
                    }
                }
                if (end !== -1) {
                    const objectStr = buffer.substring(start, end + 1);
                    lastParsedIndex = end + 1;
                    try {
                        const parsed = JSON.parse(objectStr);
                        accumulatedResponse += parsed.candidates?.[0]?.content?.parts?.[0]?.text || '';
                    } catch (e) {
                        console.warn("Failed to parse stream:", objectStr);
                    }
                } else break;
            }
            if (lastParsedIndex > 0) buffer = buffer.substring(lastParsedIndex);
            renderContent(responseContentContainer, accumulatedResponse);
            scrollToBottom();
        }
    } catch (error) {
        console.error("Error calling Gemini API:", error);
        hideTypingIndicator();
        if (responseContentContainer) responseContentContainer.parentElement.classList.remove('streaming');
        const errorContainer = addBotMessage(``, false, true, -1);
        renderContent(errorContainer, `抱歉，出了点问题。\n\n**错误：**\n\`\`\`\n${error.message}\n\`\`\``);
        scrollToBottom();
    }
};

const handleSendMessage = async () => {
    const text = messageInput.value.trim();
    if (text === '' && uploadedImagesData.length === 0) return;

    if (!currentChatId) {
        currentChatId = Date.now().toString();
    }

    const imagesToSend = [...uploadedImagesData];
    const imagePartsForHistory = imagesToSend.map(dataUrl => {
        const [header, base64Data] = dataUrl.split(',');
        const mimeType = header.match(/:(.*?);/)[1];
        return {
            inlineData: {
                mimeType: mimeType,
                data: base64Data
            }
        };
    });
    const textPart = {
        text: text
    };
    const userParts = [textPart, ...imagePartsForHistory];
    const userMessage = {
        role: "user",
        parts: userParts
    };

    if (chatHistory.length === 0) {
        chatMessages.innerHTML = '';
    }

    chatHistory.push(userMessage);
    if (currentChatId) {
        conversations[currentChatId] = chatHistory;
        saveConversationsToStorage();
    }

    renderChatMessages();
    renderConversationHistory();

    const apiText = text;
    const apiImages = [...uploadedImagesData];

    messageInput.value = '';
    autoResizeTextarea();
    imagePreviewContainer.innerHTML = '';
    uploadedImagesData = [];
    imageUploadInput.value = '';
    updateSendButtonState();

    await callGeminiApi(apiText, apiImages);
};

// --- UI Helper Functions ---
const autoResizeTextarea = () => {
    messageInput.style.height = 'auto';
    const lineHeight = 24;
    const maxAutoHeight = lineHeight * 5;
    const scrollHeight = messageInput.scrollHeight;
    if (scrollHeight > maxAutoHeight) {
        messageInput.style.height = `${maxAutoHeight}px`;
        enlargeButton.classList.remove('hidden');
    } else {
        messageInput.style.height = `${scrollHeight}px`;
        enlargeButton.classList.add('hidden');
    }
};
const renderImagePreviews = () => {
    imagePreviewContainer.innerHTML = '';
    uploadedImagesData.forEach((imageData, index) => {
        const previewWrapper = document.createElement('div');
        previewWrapper.className = 'relative p-2';
        previewWrapper.innerHTML = `<img src="${imageData}" class="h-24 w-24 object-cover rounded-md"><button onclick="removeImagePreview(${index})" class="absolute top-0 right-0 bg-red-500 text-white rounded-full h-5 w-5 flex items-center justify-center text-xs">&times;</button>`;
        imagePreviewContainer.appendChild(previewWrapper);
    });
    updateSendButtonState();
};
const handleImageUpload = (event) => {
    const files = event.target.files;
    if (!files) return;
    if (uploadedImagesData.length + files.length > 5) {
        alert("您最多可以上传 5 张图片。");
        return;
    }
    for (const file of files) {
        if (!['image/jpeg', 'image/png'].includes(file.type)) {
            alert(`无效的文件类型：${file.type}。请上传有效的图片。`);
            continue;
        }
        if (file.size > 5 * 1024 * 1024) {
            alert(`文件 ${file.name} 太大。最大尺寸为 5MB。`);
            continue;
        }
        const reader = new FileReader();
        reader.onload = (e) => {
            uploadedImagesData.push(e.target.result);
            renderImagePreviews();
        };
        reader.readAsDataURL(file);
    }
    imageUploadInput.value = '';
};
window.removeImagePreview = (index) => {
    uploadedImagesData.splice(index, 1);
    renderImagePreviews();
};

// --- Event Listeners ---
sendButton.addEventListener('click', handleSendMessage);
messageInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        handleSendMessage();
    }
});
messageInput.addEventListener('input', () => {
    autoResizeTextarea();
    updateSendButtonState();
});
uploadImageButton.addEventListener('click', () => imageUploadInput.click());
imageUploadInput.addEventListener('change', handleImageUpload);
enlargeButton.addEventListener('click', () => {
    messageInput.classList.toggle('enlarged');
    enlargeIcon.classList.toggle('hidden');
    shrinkIcon.classList.toggle('hidden');
    if (!messageInput.classList.contains('enlarged')) autoResizeTextarea();
    else messageInput.style.height = '240px';
});
chatMessages.addEventListener('click', (e) => {
    const copyButton = e.target.closest('.copy-btn');
    const editButton = e.target.closest('.edit-btn');
    const image = e.target.closest('.chat-image');
    const saveButton = e.target.closest('.save-edit-btn');
    const cancelButton = e.target.closest('.cancel-edit-btn');

    if (saveButton) {
        const messageIndex = parseInt(saveButton.dataset.index);
        if (!isNaN(messageIndex)) {
            confirmEdit(messageIndex);
        }
        return;
    }

    if (cancelButton) {
        cancelEdit();
        return;
    }

    if (currentlyEditingIndex !== null) return;

    if (copyButton) {
        const messageIndex = parseInt(copyButton.dataset.index);
        if (!isNaN(messageIndex) && chatHistory[messageIndex]) {
            const textToCopy = chatHistory[messageIndex].parts.find(p => p.text)?.text || '';
            copyToClipboard(textToCopy, copyButton);
        }
    } else if (editButton) {
        const messageIndex = parseInt(editButton.dataset.index);
        if (!isNaN(messageIndex)) {
            handleEditMessage(messageIndex);
        }
    } else if (image) {
        modalImage.src = image.src;
        imageModal.classList.remove('hidden');
        imageModal.classList.add('flex');
    }
});
const closeModal = () => {
    imageModal.classList.add('hidden');
    imageModal.classList.remove('flex');
    modalImage.src = '';
};
modalCloseButton.addEventListener('click', closeModal);
imageModal.addEventListener('click', (e) => {
    if (e.target === imageModal) closeModal();
});

// --- Sidebar and Conversation Listeners ---
const closeSidebar = () => {
    const isMobile = window.innerWidth < 768;
    if (isMobile) {
        sidebar.classList.remove('open');
        sidebarOverlay.classList.add('hidden');
    } else {
        appContainer.classList.add('sidebar-collapsed');
    }
}
sidebarToggleOpen.addEventListener('click', (e) => {
    e.stopPropagation();
    const isMobile = window.innerWidth < 768;
    if (isMobile) {
        sidebar.classList.add('open');
        sidebarOverlay.classList.remove('hidden');
    } else {
        appContainer.classList.toggle('sidebar-collapsed');
    }
});
sidebarToggleClose.addEventListener('click', closeSidebar);
sidebarOverlay.addEventListener('click', closeSidebar);

modelSelect.addEventListener('change', (e) => {
    geminiModel = e.target.value;
    localStorage.setItem('geminiModel', geminiModel);
});

newChatButton.addEventListener('click', startNewChat);
importChatButton.addEventListener('click', () => importChatInput.click());
importChatInput.addEventListener('change', importChat);

clearStorageButton.addEventListener('click', () => {
    if (confirm('您确定要清除所有数据吗？这将删除您的 API 密钥和所有聊天记录。')) {
        localStorage.clear();
        location.reload();
    }
});

conversationHistoryContainer.addEventListener('click', (e) => {
    const target = e.target.closest('.conversation-item, .delete-chat-btn, .download-chat-btn');
    if (!target) return;
    const id = target.dataset.id;
    if (target.classList.contains('delete-chat-btn')) {
        e.stopPropagation();
        deleteChat(id);
    } else if (target.classList.contains('download-chat-btn')) {
        e.stopPropagation();
        downloadChat(id);
    } else if (target.classList.contains('conversation-item')) {
        loadChat(id);
        if (window.innerWidth < 768) closeSidebar();
    }
});
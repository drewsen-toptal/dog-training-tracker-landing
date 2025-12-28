const fs = require('fs');
const path = require('path');

// Create screenshots directory if it doesn't exist
const screenshotsDir = path.join(__dirname, 'public', 'screenshots');
if (!fs.existsSync(screenshotsDir)) {
  fs.mkdirSync(screenshotsDir, { recursive: true });
}

// Source directory
const sourceDir = '/Users/drew.sen/.playwright-mcp';

// Files to copy
const files = [
  { src: 'progress-dashboard.png', dest: 'progress-dashboard.png' },
  { src: 'clicker.png', dest: 'clicker.png' },
  { src: 'command-library.png', dest: 'command-library.png' }
];

// Copy files
files.forEach(file => {
  const sourcePath = path.join(sourceDir, file.src);
  const destPath = path.join(screenshotsDir, file.dest);

  try {
    fs.copyFileSync(sourcePath, destPath);
    console.log(`✓ Copied ${file.src} to public/screenshots/`);
  } catch (error) {
    console.error(`✗ Error copying ${file.src}:`, error.message);
  }
});

console.log('\nAll screenshots copied successfully!');

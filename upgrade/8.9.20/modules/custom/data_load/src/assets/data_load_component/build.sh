yarn install
npm run build
cp build/service-worker.js ../assets/data-upload-tool/service-worker.js
cp build/static/js/main.*.js ../assets/data-upload-tool/main.js
cp build/static/css/main.*.css ../assets/data-upload-tool/main.css

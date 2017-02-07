npm run build
cp build/static/js/main*.js ../assets/js/main.fundingorg.js
cp build/static/css/main*.css ../assets/css/main.fundingorg.css
cd /var/www/html
drush cr

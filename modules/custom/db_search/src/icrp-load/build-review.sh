ng build -prod
cp dist/styles*.css ../../load_assets/styles.css
cp dist/inline*.js ../../load_assets/inline.js
cp dist/main*.js ../../load_assets/main.js
cp dist/polyfills*.js ../../load_assets/polyfills.js
cp dist/vendor*.js ../../load_assets/vendor.js


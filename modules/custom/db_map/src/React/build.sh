#!/bin/bash

npm run build
cp build/static/css/main.*.css ../assets/main.css
cp build/static/js/main.*.js ../assets/main.js
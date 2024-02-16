#!/bin/bash
cd /var/www/myapp
npm install
npm run build
nohup npm run start > output.log 2>&1 &
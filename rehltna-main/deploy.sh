#!/bin/bash
HOST="premium54.web-hosting.com"
USER="rehltwoz"
PORT="21098"
REMOTE_APP="~/admin.rehltna.com"

echo "==> Syncing files..."
rsync -avz --progress -e "ssh -p $PORT" \
  --exclude='.env' \
  --exclude='node_modules' \
  --exclude='vendor' \
  --exclude='storage/logs' \
  --exclude='.git' \
  --exclude='deploy.sh' \
  --exclude='public/uploads' \
  --exclude='public/sitemaps' \
  --exclude='public/sitemap.xml' \
  ./ $USER@$HOST:$REMOTE_APP/

echo "==> Clearing cache on server..."
ssh -p $PORT $USER@$HOST "cd $REMOTE_APP && php artisan config:cache && php artisan route:cache && php artisan view:cache"

echo "==> Done! Site is updated."

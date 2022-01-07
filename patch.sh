#!/usr/bin/env sh

SOURCE_COMMIT_HASH='81fd4cf3911fdfd59dc76ed791a6e33dac8c775b'

git config --global init.defaultBranch 'main'
git config --global user.email '74628488+squili@users.noreply.github.com'
git config --global user.name 'Squili'

if [ -d 'serenity' ]; then
    rm -rf serenity
fi

git clone https://github.com/serenity-rs/serenity

cd serenity || exit 1
git checkout -q $SOURCE_COMMIT_HASH
rm -rf .git
rm -r .github

git init
git add .
git commit -m "Init from $SOURCE_COMMIT_HASH"

for file in ../patches/* ; do
  patch_name="$(basename "$file" | head -c -7)"
  echo "Apply patch $patch_name"
  git apply "$file"
  git add .
  git commit -m "Patch $patch_name"
done

git branch -M main
git remote add origin "https://squili:$API_TOKEN@github.com/squili/serenity-makita.git"
git push origin main -f

cd ..

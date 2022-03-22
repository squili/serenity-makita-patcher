#!/usr/bin/env sh

SOURCE_COMMIT_HASH='c2b86265574c5713c774495dc6a926cb01a84dd0'

git config --global init.defaultBranch 'main'
git config --global user.email 'git@squi.live'
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

#!/usr/bin/env sh

SOURCE_COMMIT_HASH='81fd4cf3911fdfd59dc76ed791a6e33dac8c775b'

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

git remote add origin https://github.com/squili/serenity-makita.git
git push origin master -f

cd ..

#!/bin/sh

export GITHUB_REPONAME="gvolpe/gvolpe.github.io"
export GITHUB_REPO_BRANCH="master"

echo "Generating static site"
hexo generate

echo "Copying files into tmp directory"
mkdir tmp
cp -R public/. tmp/
cd tmp/

echo "Publishing blog to gh-pages at `date`"
git init
git add .
git commit -m "Site updated at `date`"
git remote add origin git@github.com:$GITHUB_REPONAME.git
git push origin master:refs/heads/$GITHUB_REPO_BRANCH --force

echo "Done"
cd ..
rm -rf tmp

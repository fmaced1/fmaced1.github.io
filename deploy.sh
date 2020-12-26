#!/bin/sh

#git clone https://github.com/adityatelange/hugo-PaperMod themes/hugo-PaperMod --depth=1
#git submodule add -b main https://github.com/fmaced1/fmced1.github.io.git public

# If a command fails then the deploy stops
set -e

rm -rf ./public/* ./docs/*

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
hugo -t hugo-PaperMod # if using a theme, replace with `hugo -t <YOURTHEME>`

mv ./public/ ./docs/

# Add changes to git.
git add *

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin main
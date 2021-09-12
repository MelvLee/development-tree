#!/bin/sh

CreatePackageJsonFile()
{
  if [[ ! -f package.json ]]
  then
    npm init -y

    echo node_modules >> .gitignore
  fi
}

InstallAndSetupCommitizen()
{
  if [[ `npm list | grep -c commitizen` = 0 ]]
  then
    npm i -D commitizen

    npx commitizen init cz-conventional-changelog --save-dev --save-exact

    npm set-script cz:commit cz
  fi
}

InstallAndSetupHusky()
{
  if [[ `npm list | grep -c husky` = 0 ]]
  then
    npm i -D husky

    npx husky install
  fi
}

InstallAndSetupCommitlint()
{
  if [[ `npm list | grep -c @commitlint/cli` = 0 ]]
  then
    npm i -D @commitlint/{config-conventional,cli}

    echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js

    npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'
  fi
}

StageAndCommitChanges()
{
  git add .gitignore commitlint.config.js package-lock.json package.json .husky/commit-msg
  git commit -m "chore: setup Conventional Commits"
}

CreatePackageJsonFile
InstallAndSetupCommitizen
InstallAndSetupHusky
InstallAndSetupCommitlint
StageAndCommitChanges

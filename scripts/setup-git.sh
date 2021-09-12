#!/bin/sh

CreateAndSetupGitRepository()
{
  if [[ ! -d .git && ! $(git rev-parse --is-inside-work-tree) ]]
  then
    git init

    # rename current branch to 'main'
    git branch -M main
  fi
}

CreateGitignoreFile()
{
  if [[ ! -f .gitignore ]]
  then
    touch .gitignore

    echo created .gitignore file
  fi
}

CreateReadMeMarkdownFile()
{
  if [[ ! -f README.md ]]
  then
    echo "#" ${PWD##*/} >> README.md

    echo created README.md
  fi
}

StageAndCommitChanges()
{
  git add README.md .gitignore
  git commit -m "chore: create .gitignore and README.md files"
}

CreateAndSetupGitRepository
CreateGitignoreFile
CreateReadMeMarkdownFile
StageAndCommitChanges

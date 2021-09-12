#!/bin/sh

CreateRejectProtectedBranchCommitScript()
{
  if [[ ! -f scripts/reject-protected-branch-commit.sh ]]
  then
    echo "#!/bin/sh

branch=\"\$(git rev-parse --abbrev-ref HEAD)\"

if [[ \"\$branch\" = \"main\" ]]
then
  echo \"You can't commit directly to main branch\"
  exit 1
fi" >> scripts/reject-protected-branch-commit.sh
  fi
}

CreateHuskyPrecommitScript()
{
  if [[ ! -f .husky/pre-commit ]]
  then
    npx husky add .husky/pre-commit 'sh scripts/reject-protected-branch-commit.sh'
  fi
}

StageAndCommitChanges()
{
  git checkout -b chore/setup-reject-local-commit-to-protected-branch
  git add .husky/pre-commit scripts/reject-protected-branch-commit.sh
  git commit -m "chore: setup reject local commit to protected branch"
}

CreateRejectProtectedBranchCommitScript
CreateHuskyPrecommitScript
StageAndCommitChanges

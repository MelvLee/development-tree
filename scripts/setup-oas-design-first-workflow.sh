#!/bin/sh

CreateOASFilesFolder()
{
  if [[ ! -d src ]]
  then
    mkdir src
  fi

  if [[ ! -d src/oas ]]
  then
    mkdir src/oas
  fi

  if [[ ! -d src/oas/paths ]]
  then
    mkdir src/oas/paths
  fi

  if [[ ! -d src/oas/components ]]
  then
    mkdir src/oas/components
  fi

  if [[ ! -d src/oas/components/headers ]]
  then
    mkdir src/oas/components/headers
  fi

  if [[ ! -d src/oas/components/parameters ]]
  then
    mkdir src/oas/components/parameters
  fi

  if [[ ! -d src/oas/components/responses ]]
  then
    mkdir src/oas/components/responses
  fi

  if [[ ! -d src/oas/components/schemas ]]
  then
    mkdir src/oas/components/schemas
  fi
}

CreateMinimalOASFile()
{
  if [[ ! -f src/oas/openapi.yaml ]]
  then
    echo "openapi: 3.0.3
info:
  title: API Design First using OpenAPI specification
  version: 1.0.0
paths: {}
" >> src/oas/openapi.yaml
  fi
}

InstallAndSetupSpectral()
{
  if [[ `npm list | grep -c spectral-cli` = 0 ]]
  then
    npm i -D @stoplight/spectral-cli

    npm set-script oas:lint "spectral lint src/oas/**/*.yaml"

    npx husky add .husky/pre-commit "npm run oas:lint"
  fi

  if [[ ! -f .spectral.yaml ]]
  then
    echo "extends: spectral:oas" >> .spectral.yaml
  fi
}

CreateLintOASFilesGitHubActionFile()
{
  if [[ ! -d .github ]]
  then
    mkdir .github
  fi

  if [[ ! -d .github/workflows ]]
  then
    mkdir .github/workflows
  fi
  
  if [[ ! -f .github/workflows/lint-openapi-specification-files.yaml ]]
  then
    echo "name: lint OpenAPI specification files

on:
  push:
    paths:
    - src/oas/**/*.yaml
    - .github/workflows/lint-openapi-specification-files.yaml
  workflow_dispatch:

jobs:
  lint-oas:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v1
        with:
          node-version: 14
      - name: Install dependencies
        run: npm install
      - name: Lint OpenAPI specification files
        run: npm run oas:lint
" >> .github/workflows/lint-openapi-specification-files.yaml
  fi
}

StageAndCommitChanges()
{
  git checkout -b chore/setup-oas-design-first-workflow
  git add .spectral.yaml package-lock.json package.json .github/workflows/lint-openapi-specification-files.yaml .husky/pre-commit src/oas/openapi.yaml
  git commit -m "chore: setup OAS design first workflow"
}

CreateOASFilesFolder
CreateMinimalOASFile
InstallAndSetupSpectral
CreateLintOASFilesGitHubActionFile
StageAndCommitChanges

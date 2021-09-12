#!/bin/sh

InstallAndSetupRedoclyOpenApiCli()
{
  if [[ `npm list | grep -c @redocly/openapi-cli` = 0 ]]
  then
    npm i -D @redocly/openapi-cli

    npm set-script oas:bundle-yaml "openapi bundle --output dist/oas/openapi.yaml src/oas/openapi.yaml"
  fi
}

CreateSecurityScanOASFilesGitHubActionFile()
{
  if [[ ! -f 42c-conf.yaml ]]
  then
    echo "audit:
  branches:
    '*':
      discovery:
        search:
          - 'dist/oas/openapi.yaml'
      fail_on:
        score:
          data: 30 # max: 70
          security: 10 # max: 30
" >> 42c-conf.yaml
  fi

  if [[ ! -f .github/workflows/security-scan-openapi-specification-files.yaml ]]
  then
    echo "name: security scan OpenAPI specification files
on:
  workflow_run:
    workflows:
    - \"lint OpenAPI specification files\"
    types:
    - completed
  push:
    paths:
    - .github/workflows/security-scan-openapi-specification-files.yaml
  workflow_dispatch:

jobs:
  static-security-scan-oas:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v1
        with:
          node-version: 14
      - name: Install dependencies
        run: npm install
      - name: Bundle OpenAPI specification files
        run: npm run oas:bundle-yaml
      - name: 42Crunch REST API Static Security Testing
        uses: 42Crunch/api-security-audit-action@v2
        with:
          api-token: \${{ secrets.SECURITY_SCAN_API_TOKEN }}
          upload-to-code-scanning: true
          github-token: \${{ secrets.GITHUB_TOKEN }}
" >> .github/workflows/security-scan-openapi-specification-files.yaml
  fi
}

StageAndCommitChanges()
{
  git add 42c-conf.yaml package-lock.json package.json .github/workflows/security-scan-openapi-specification-files.yaml
  git commit -m "chore: setup static security scan OAS files"
}

InstallAndSetupRedoclyOpenApiCli
CreateSecurityScanOASFilesGitHubActionFile
StageAndCommitChanges

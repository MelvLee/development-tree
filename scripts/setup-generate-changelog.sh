#!/bin/sh

InstallAndSetupStandardVersion()
{
  if [[ `npm list | grep -c standard-version` = 0 ]]
  then
    npm i -D standard-version

    npm set-script release "standard-version"
    npm set-script release:minor "standard-version --release-as minor"
    npm set-script release:patch "standard-version --release-as patch"
    npm set-script release:major "standard-version --release-as major"

  fi

  if [[ ! -f .versionrc.json ]]
  then
    remoteUrl="$(git remote get-url origin)"

    echo "{
    \"types\": [
      {\"type\": \"feat\", \"section\": \"Features\"},
      {\"type\": \"fix\", \"section\": \"Bug Fixes\"},
      {\"type\": \"chore\", \"hidden\": true},
      {\"type\": \"docs\", \"hidden\": true},
      {\"type\": \"style\", \"hidden\": true},
      {\"type\": \"refactor\", \"hidden\": true},
      {\"type\": \"perf\", \"hidden\": true},
      {\"type\": \"test\", \"hidden\": true}
    ],
    \"commitUrlFormat\": \"${remoteUrl%.git}/commits/{{hash}}\",
    \"compareUrlFormat\": \"${remoteUrl%.git}/compare/{{previousTag}}...{{currentTag}}\"
  }" >> .versionrc.json
  fi
}

InstallAndSetupStandardVersion
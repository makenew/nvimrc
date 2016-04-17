#!/usr/bin/env sh

set -e
set -u

find_replace () {
  git ls-files -z | xargs -0 sed -i "$1"
}

check_env () {
  test -d .git || (echo 'This is not a Git repository. Exiting.' && exit 1)
  for cmd in ${1}; do
    command -v ${cmd} >/dev/null 2>&1 || \
      (echo "Could not find '$cmd' which is required to continue." && exit 2)
  done
  echo
  echo 'Ready to bootstrap your new plugin!'
  echo
}

stage_env () {
  echo
  git rm -f makenew.sh
  echo
  echo 'Staging changes.'
  git add --all
  echo
  echo 'Done!'
  echo
}

makenew () {
  read -p '> Version number: ' mk_version
  read -p '> Author name: ' mk_author
  read -p '> Copyright owner: ' mk_owner
  read -p '> Copyright year: ' mk_year
  read -p '> GitHub user or organization name: ' mk_user
  read -p '> GitHub repository name: ' mk_repo

  sed -i -e '3d;22,107d;224,227d' README.md

  find_replace "s/0\.0\.0/${mk_version}/g"
  find_replace "s/2016 Evan Sosenko/${mk_year} ${mk_owner}/g"
  find_replace "s/Evan Sosenko/${mk_author}/g"
  find_replace "s/makenew\/nvimrc/${mk_user}\/${mk_repo}/g"

  mk_attribution='> Built from [makenew/nvimrc](https://github.com/makenew/nvimrc).'
  sed -i -e "6i ${mk_attribution}\n" README.md

  echo
  echo 'Replacing boilerplate.'
}

check_env 'git read sed xargs'
makenew
stage_env
exit

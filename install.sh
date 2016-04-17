#!/bin/env sh

main () {
  set -e
  set -u

  repo='makenew/nvimrc'

  config_home=$XDG_CONFIG_HOME
  nvim_root="${config_home}/nvim"

  if [ "${1:-}" == 'dev' ]; then
    dev_mode
  else
    install_nvimrc
  fi
}

install_nvimrc () {
  echo -e "\033[32m➤ Installing!   \033[0m"

  command -v nvim >/dev/null 2>&1 \
    && echo -e "\033[32m  ✔ Found         ❰ Neovim ❱   \033[0m" \
    || {
      echo -e "\033[31m  ✘ Missing       ❰ Neovim ❱   \033[0m"
      echo -e "\033[31m✘ Install failed!"
      exit 1
    }

  command -v git >/dev/null 2>&1 \
    && echo -e "\033[32m  ✔ Found         ❰ Git ❱   \033[0m" \
    || {
      echo -e "\033[31m  ✘ Missing       ❰ Git ❱   \033[0m"
      echo -e "\033[31m✘ Install failed!"
      exit 1
    }

  if [ -d $nvim_root ]; then
    echo -e "\033[32m  ✔ Exists        ❰ ${nvim_root} ❱   \033[0m"
  else
    echo -e "  ➤ Creating      ❰ ${nvim_root} ❱   \033[0m"

    mkdir -p $nvim_root

    echo -e "\033[32m    ✔ Created     ❰ ${nvim_root} ❱   \033[0m"
  fi

  if [ -e $nvim_root/autoload/plug.vim ]; then
    echo -e "\033[32m  ✔ Found         ❰ vim-plug ❱   \033[0m"
  else
    echo -e "  ➤ Installing    ❰ vim-plug ❱   \033[0m"

    command -v git >/dev/null 2>&1 && \
      env git clone https://github.com/junegunn/vim-plug \
      $nvim_root/autoload >/dev/null 2>&1

    echo -e "\033[32m    ✔ Installed   ❰ vim-plug ❱   \033[0m"
  fi

  if [ -f $nvim_root/init.vim ] || [ -h $nvim_root/init.vim ]; then
    nvimrc_line=$(head -n 1 $nvim_root/init.vim)

    if [ "$nvimrc_line" != "\" ${repo}" ]; then
      echo -e "  ➤  Exists       ❰ ${nvim_root}/init.vim ❱   \033[0m"

      mv $nvim_root/init.vim $nvim_root/init.vim.preinstall

      echo -e "\033[32m    ✔ Moved to    ❰ ${nvim_root}/init.vim.preinstall ❱   \033[0m"
    else
      rm $nvim_root/init.vim
    fi
  fi

  echo -e "  ➤ Installing    ❰ $nvim_root/init.vim ❱   \033[0m"

  tee $nvim_root/init.vim >/dev/null <<EOF
" $repo

call plug#begin(\$XDG_CONFIG_HOME . '/nvim/plugged')

if filereadable(\$XDG_CONFIG_HOME . '/nvim/plugged/nvimrc/plugins.vim')
  source \$XDG_CONFIG_HOME/nvim/plugged/nvimrc/plugins.vim
  if !\$NVIMRC_INSTALL == 'true'
    Plug '$repo'
  endif
else
  Plug '$repo', { 'on': [] }
endif

call plug#end()
EOF

  echo -e "\033[32m    ✔ Installed   ❰ ${nvim_root}/init.vim ❱   \033[0m"

  echo -e "  ➤ Run           ❰ PlugInstall ❱   \033[0m"

  nvim -c PlugInstall -c qall!
  NVIMRC_INSTALL=true nvim -c PlugInstall -c qall!
  nvim -c PlugClean! -c qall!

  echo
  echo -e "\033[32m    ✔ Completed   ❰ PlugInstall ❱   \033[0m"
  echo -e "\033[32m✔ Install complete!   \033[0m"
  exit 0
}

dev_mode () {
  f_str[0]="call plug#begin(\$XDG_CONFIG_HOME . '/nvim/plugged')"
  r_str[0]="call plug#begin(\$XDG_CONFIG_HOME . '/nvim/plugged.dev')"

  f_str[1]="Plug '${repo}'"
  r_str[1]="Plug '$(pwd)'"

  f_str[2]="\$XDG_CONFIG_HOME . '/nvim/plugged/nvimrc/plugins.vim'"
  r_str[2]="'' . '$(pwd)/plugins.vim'"

  f_str[3]='$XDG_CONFIG_HOME/nvim/plugged/nvimrc/plugins.vim'
  r_str[3]="$(pwd)/plugins.vim"

  echo -e "\033[32m➤ Entering development mode!   \033[0m"

  i=0
  while [ $i -lt ${#f_str[@]} ]; do
    sed -i -e "s|${f_str[$i]}|${r_str[$i]}|g" $nvim_root/init.vim
    i=$(( i + 1 ))
  done

  nvim -c PlugInstall -c PlugClean! -c PlugUpdate -c qall!

  echo -e "\033[32m  ✔ Neovim now using nvimrc from this directory. \033[0m"
  echo -e "\033[32m  ➤ Run ./install.sh again to exit development mode. \033[0m"
}

main $1

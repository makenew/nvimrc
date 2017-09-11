# Neovim Configuration

[<img src="https://makenew.github.io/makenew.svg" alt="Make New" height="20">](https://makenew.github.io/)
[![GitHub releases](https://img.shields.io/github/release/makenew/nvimrc.svg)](https://github.com/makenew/nvimrc/releases)
[![GitHub license](https://img.shields.io/github/license/makenew/nvimrc.svg)](./LICENSE.txt)

> Built from [makenew.github.io](https://makenew.github.io/).

[Neovim] configuration as a Neovim plugin.

[Neovim]: https://neovim.io/

## Description

This configuration system works as a meta-plugin:
all desired Neovim plugins are loaded from `plugins.vim` using [vim-plug],
and any GUI specific options are set in `gui.vim`.
Overall configuration then follows a normal plugin structure.

For documentation of this Neovim configuration,
see `:help nvimrc` or view [nvimrc.txt](./doc/nvimrc.txt) directly.

[vim-plug]: https://github.com/junegunn/vim-plug

### Bootstrapping a New Config

1. Clone the master branch of this repository with

   ```
   $ git clone --single-branch https://github.com/makenew/nvimrc.git
   $ cd nvimrc
   ```

   Optionally, reset to the latest [release][Releases] with

   ```
   $ git reset --hard nvimrc-v1.3.4
   ```

2. Run

   ```
   $ ./makenew.sh
   ```

   and follow the prompts.
   This will replace the boilerplate, delete itself,
   stage changes for commit, remove tags, and set upstream.
   This script assumes the project repository will be hosted on GitHub.
   For an alternative location, you must update the URLs manually.

3. If [choosing a license][Choose a license] other than the one provided:
   update `LICENSE.txt` and the README License section with your chosen license.

4. After committing the initial changes, host your `install.sh` on
   GitHub pages with

   ```
   $ git checkout --orphan gh-pages
   $ git reset
   $ git add install.sh
   $ git commit -m 'Add install.sh'
   $ git push --set-upstream origin gh-pages
   $ git clean -fdx
   $ git checkout master
   ```

   Then, update the install URLs in this README
   (optionally, use [Git.io] to shorten them).

5. Document your configuration in `doc/nvimrc.txt`.

[Choose a license]: http://choosealicense.com/
[Git.io]: https://git.io/
[Releases]: https://github.com/makenew/nvimrc/releases
[The Unlicense]: http://unlicense.org/UNLICENSE

### Updating

If you want to pull in future updates from this skeleton,
you can fetch and merge in changes from this repository.

Add this as a new remote with

```
$ git remote add upstream https://github.com/makenew/nvimrc.git
```

You can then fetch and merge changes with

```
$ git fetch --no-tags upstream
$ git merge upstream/master
```

#### Changelog

Note that `CHANGELOG.md` is just a template for this skeleton.
The actual changes for this project are documented in the commit history
and summarized under [Releases].

## Installation

### Automatic Install

You can install this via the command-line with either curl

```
$ curl -L https://git.io/vwYYX | sh
```

or wget

```
$ wget https://git.io/vwYYX -O - | sh
```

### Manual Install

1. Install [vim-plug].

2. Create `~/.config/nvim/init.vim` with

   ```vim
   " makenew/nvimrc

   if empty($XDG_CONFIG_HOME)
     let $XDG_CONFIG_HOME = $HOME . '/.config'
   endif

   call plug#begin($XDG_CONFIG_HOME . '/nvim/plugged')

   if filereadable($XDG_CONFIG_HOME . '/nvim/plugged/nvimrc/plugins.vim')
     source $XDG_CONFIG_HOME/nvim/plugged/nvimrc/plugins.vim
     if $NVIMRC_INSTALL != 'true'
       Plug 'makenew/nvimrc'
     endif
   else
     Plug 'makenew/nvimrc', { 'on': [] }
   endif

   call plug#end()
   ```

   and `~/.config/nvim/ginit.vim` with

   ```vim
   " makenew/nvimrc

   if empty($XDG_CONFIG_HOME)
     let $XDG_CONFIG_HOME = $HOME . '/.config'
   endif

   source $XDG_CONFIG_HOME/nvim/plugged/nvimrc/gui.vim
   ```

3. Run

   ```
   $ nvim +PlugInstall +qa
   $ NVIMRC_INSTALL=true nvim +PlugInstall +qa
   ```

### Updating

Updating is handled via the normal [vim-plug commands].

Here is an example of a shell function that will provide a one-step update:

```zsh
# Upgrade nvimrc.
nvimupg () {
  if ! [[ -e $XDG_CONFIG_HOME/nvim/autoload/plug.vim ]]; then
    echo 'vim-plug is not installed.'
    return 1
  fi

  nvim +PlugUpgrade +qa
  nvim +PlugUpdate +qa
  nvim +PlugInstall +qa
  nvim +PlugClean! +qa
}
```

[vim-plug commands]: https://github.com/junegunn/vim-plug#commands

## Development and Testing

### Source Code

The [nvimrc source] is hosted on GitHub.
Clone the project with

```
$ git clone https://github.com/makenew/nvimrc.git
```

[nvimrc source]: https://github.com/makenew/nvimrc

### Local Development Mode

You can switch to development mode
which will configure vim-plug to use the local
directory as the plugin path.

First, follow the normal install steps if you haven't already.
Then, switch to development mode with

```
$ ./install.sh dev
```

Switch out of development mode with

```
$ ./install.sh
```

## Contributing

Please submit and comment on bug reports and feature requests.

To submit a patch:

1. Fork it (https://github.com/makenew/nvimrc/fork).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Make changes.
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create a new Pull Request.

## License

This software can be used freely, see [The Unlicense].
The copyright text appearing below and elsewhere in this repository
is for demonstration purposes only and does not apply to this software.

This Neovim config is licensed under the MIT license.

## Warranty

This software is provided by the copyright holders and contributors "as is" and
any express or implied warranties, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose are
disclaimed. In no event shall the copyright holder or contributors be liable for
any direct, indirect, incidental, special, exemplary, or consequential damages
(including, but not limited to, procurement of substitute goods or services;
loss of use, data, or profits; or business interruption) however caused and on
any theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use of this
software, even if advised of the possibility of such damage.

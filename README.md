Dotfiles
========

This is my collection of [configuration files](http://dotfiles.github.io/).

Usage
-----

Pull the repository and [use GNU stow](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/) to link create sym links.

```sh
$ git clone git@github.com:ammgws/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
$ stow wynn_v1  # this will symlink `~/.dotfiles/wynn_v1/.config/wynn` to `~/.config/wynn/`
```

For example, say a program called `wynn` stores its config in `~/.config/wynn/`.

In order to have GNU Stow symlink correctly, the directory structure inside this repo should be as follows.
`~/.dotfiles/<A>/.config/<B>` where:
 - `<B>` is `wynn` from above, and
 - `<A>` is the name used with GNU Stow. Can be the same as `<B>`, or you could have different configs
         for multiple versions of a program by using `wynn_v1`, `wynn_v2` etc.

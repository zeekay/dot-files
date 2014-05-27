#!/usr/bin/env bash
#
# zeekay/files
#
# Dotfiles for various common bsd/unix utilities.

pkg_deps=(
    zeekay/zsh
    zeekay/vim
    zeekay/irssi
)

pkg.link() {
    fs.link_files common

    case $(os.platform) in
        cygwin)
            fs.link_files platform/cygwin
            ;;
        osx)
            fs.link_files platform/osx
            ;;
        freebsd)
            fs.link_files platform/freebsd
            ;;
        linux)
            fs.link_files platform/linux
            ;;
    esac
}

pkg.install() {
    git config --global --unset-all include.path '~/.gitinclude'
    git config --global --add include.path '~/.gitinclude'
    cat <<\EOF

Included ~/.gitinclude in your ~/.gitconfig automatically. You can manually set
user.email, user.name, and github.username with `git config`:

    git config --global user.name "Zach Kelling"
    git config --global user.email "zk@monoid.io"
    git config --global github.username "zeekay"

EOF
}

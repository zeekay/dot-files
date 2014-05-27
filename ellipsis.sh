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
    echo "Including ~/.gitinclude in ~/.gitconfig"
    git config --global include.path '~/.gitinclude'
}

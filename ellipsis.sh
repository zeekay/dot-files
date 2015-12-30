#!/usr/bin/env bash
#
# zeekay/files
#
# Dotfiles for various common bsd/unix utilities.

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

git-configured() {
    for key in user.name user.email github.user; do
        if [ -z "$(git config --global $key | cat)"  ]; then
            return 1
        fi
    done
    return 0
}

pkg.install() {
    git.add_include '~/.gitinclude'

    git.configured || cat <<\EOF
You should set your email, name and github user for git with `git config`:

    git config --global user.name "Zach Kelling"
    git config --global user.email "zk@monoid.io"
    git config --global github.user "zeekay"
EOF
}

#!/usr/bin/env bash
#
# zeekay/dot-files.
# Dotfiles for various common bsd/unix utilities.

pkg.install() {
    ellipsis.link_files "$PKG_PATH/common"

    case "$(utils.platform)" in
        cygwin*)
            ellipsis.link_files "$PKG_PATH/platform/cygwin"
            ;;
        darwin)
            ellipsis.link_files "$PKG_PATH/platform/osx"
            ;;
        freebsd)
            ellipsis.link_files "$PKG_PATH/platform/freebsd"
            ;;
        linux)
            ellipsis.link_files "$PKG_PATH/platform/linux"
            ;;
    esac
}

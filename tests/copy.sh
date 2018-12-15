#! /usr/bin/env bash

set -x

DOTFILES_TEST_HOME="/var/_dotfiles"
DOTFILES_TEST_ROOT="${DOTFILES_TEST_HOME}/.dotfiles"
DOTFILES_TEST_USER="_dotfiles"

[[ -d "${DOTFILES_TEST_ROOT}.backup" ]] && rm -rf "${DOTFILES_TEST_ROOT}.backup"
[[ -d "${DOTFILES_TEST_ROOT}" ]] && mv -f "${DOTFILES_TEST_ROOT}" "${DOTFILES_TEST_ROOT}.backup"
cp -r . "${DOTFILES_TEST_ROOT}"
chown -R "${DOTFILES_TEST_USER}":"${DOTFILES_TEST_USER}" "${DOTFILES_TEST_ROOT}"

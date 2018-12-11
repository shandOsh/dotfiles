echo
echo "Running generic installer"

for module_install_file in $(find "${DOTFILES_MODULES_ROOT}" -name "install.sh"); do
    . "${module_install_file}"
done

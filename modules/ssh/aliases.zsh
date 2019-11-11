#   -----------------------------
#   4.  ALIASES
#   -----------------------------

    alias ssh-add-keys='__ssh_add_keys'
    alias _="ssh_cez"

#   -----------------------------
#   5.  FUNCTIONS
#   -----------------------------

    function __ssh_add_keys() {
        if [[ ${#SSH_KEYS_LIST[@]} -eq 0 ]]; then
            >&2 echo "No SSH keys found in the list."
            return 1
        fi

        ssh-add ${SSH_KEYS_LIST[*]}
    }

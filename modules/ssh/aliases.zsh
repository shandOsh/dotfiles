#   -----------------------------
#   4.  ALIASES
#   -----------------------------

    alias ssh-add-keys='__ssh_add_keys'

#   -----------------------------
#   5.  FUNCTIONS
#   -----------------------------

    function __ssh_add_keys() {
        ssh-add ${SSH_KEYS_LIST[*]}
    }

#   -----------------------------
#   4.  ALIASES
#   -----------------------------

    alias ssh-add-keys='__ssh_add_keys'
    alias sshl='__ssh_port_tunneling'
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

    function __ssh_port_tunneling() {
        local port_local=""
        local port_remote=""
        local ssh_user=""
        local ssh_hostname=""

        case ${#} in
            2 )
                port_local="${1}"
                port_remote="${1}"
                ssh_user="$(echo "${2}" | cut -d '@' -f 1)"
                ssh_hostname="$(echo "${2}" | cut -d '@' -f 2)"
            ;;

            3 )
                port_local="${1}"
                port_remote="${2}"
                ssh_user="$(echo "${3}" | cut -d '@' -f 1)"
                ssh_hostname="$(echo "${3}" | cut -d '@' -f 2)"
            ;;

            * )
                >&2 echo
                >&2 echo "$0 <port> <user@hostname>"
                >&2 echo
                >&2 echo "or"
                >&2 echo
                >&2 echo "$0 <port-local> <port-remote> <user@hostname>"
                return 1
        esac

        ssh -L "${port_local}":"${ssh_hostname}":"${port_remote}" "${ssh_user}"@"${ssh_hostname}"
    }

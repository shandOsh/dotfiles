#   -----------------------------
#   4.  ALIASES
#   -----------------------------

#   -----------------------------
#   5.  FUNCTIONS
#   -----------------------------

    function set_git_identity() {
        local choice=0
        local git_user_name="$(git config --local user.name)"
        local git_user_mail="$(git config --local user.email)"
        local git_user_skey="$(git config --local user.signingkey)"

        if [[ "${git_user_name}" != "" ]] || [[ "${git_user_mail}" != "" ]]; then
            echo "You already have set up your git identity (${git_user_name} <${git_user_mail}>). Continue anyway?"
            echo
            echo -n "Your choice (y/n): "
            read -r choice
            echo

            case "${choice}" in
                y)
                ;;

                n)
                    return 0
                ;;

                *)
                    echo "! Invalid choice."
                    return 1
            esac
        fi

        echo "How would you like to set your git identity?"
        echo
        echo "1. from the list"
        echo "2. manually"
        echo
        echo -n "Your choice: "
        read -r choice
        echo

        case "${choice}" in
            1)
                if [[ ${#GIT_IDENTITY_LIST[*]} -eq 0 ]]; then
                    echo "! No identity defined."
                    return 1
                fi

                for git_identity_index in $(seq 1 ${#GIT_IDENTITY_LIST[*]}); do
                    echo "${git_identity_index}. ${GIT_IDENTITY_LIST[${git_identity_index}]}"
                done

                echo
                echo -n "Your choice: "
                read -r choice

                if [[ ${GIT_IDENTITY_LIST[${choice}]} == "" ]]; then
                    echo
                    echo "! Invalid choice."
                    return 1
                fi

                git_user_name="$(echo "${GIT_IDENTITY_LIST[${choice}]}" | cut -d: -f1)"
                git_user_mail="$(echo "${GIT_IDENTITY_LIST[${choice}]}" | cut -d: -f2)"
                git_user_skey="$(echo "${GIT_IDENTITY_LIST[${choice}]}" | cut -d: -f3)"
            ;;

            2)
                echo -n "What is your author name? "
                read -r git_user_name
                echo -n "What is your author email? "
                read -r git_user_mail
                echo -n "What is your signing key? "
                read -r git_user_skey

                if [[ "${git_user_name}" == "" ]] || [[ "${git_user_mail}" == "" ]]; then
                    echo
                    echo "! Neither name nor email can be empty."
                    return 1
                fi

                if [[ "${git_user_skey}" != "" ]]; then
                    gpg --list-key "${git_user_skey}" > /dev/null 2>&1
                    rc=$?

                    if [[ ${rc} -ne 0 ]]; then
                        echo
                        echo "! A key with ID ${git_user_skey} was not found."
                        return 1
                    fi
                fi
            ;;

            *)
                echo "! Invalid choice."
                return 1
        esac

        git config user.name "${git_user_name}"
        git config user.email "${git_user_mail}"

        if [[ "${git_user_skey}" != "" ]]; then
            git config commit.gpgsign true # autosign all commits/merges
            git config tag.forceSignAnnotated true # autosign all annotated tags
            git config user.signingkey "${git_user_skey}"
        fi

        echo
        echo "Git identity (${git_user_name} <${git_user_mail}>) successfully set up."
    }

    # download gitignore for given os/ide/programming language
    function download_gitignore() {
        if [[ $# -eq 0 ]]; then
            >&2 echo "No os/ide/programming language given."
            return 1
        fi

        local content="$(curl -s "https://www.gitignore.io/api/$1")"

        if [[ "${content}" =~ \#\!\!\ ERROR ]]; then
            >&2 echo "Unsupported os/ide/programming language."
            return 1
        fi

        echo "${content}"
    }

#   -----------------------------
#   4.  ALIASES
#   -----------------------------

    function gitdiff() {
        "$(git --exec-path)/git-diff" --no-index "${@}"
    }

    compdef _git gitdiff=git-diff

#   -----------------------------
#   5.  FUNCTIONS
#   -----------------------------

    function set_git_identity() {
        local choice=0
        local git_user_name="$(git config --local user.name)"
        local git_user_mail="$(git config --local user.email)"
        local git_user_skey="$(git config --local user.signingkey)"

        if [[ "${git_user_name}" != "" ]] || [[ "${git_user_mail}" != "" ]]; then
            local identity_string="${git_user_name} <${git_user_mail}>"

            if [[ "${git_user_skey}" != "" ]]; then
                identity_string+=" - sign key ID: ${git_user_skey}"
            fi

            echo
            ansi --bold --color=${FMT_ORANGE} "You already have set up your git identity (${identity_string}). Continue anyway?"
            echo
            ansi --no-newline --bold "Your choice (y/n): "
            read -r choice
            echo

            case "${choice}" in
                y)
                ;;

                n)
                    return 0
                ;;

                *)
                    ansi --bold --color=${FMT_RED} "! Invalid choice."
                    return 1
            esac
        fi

        ansi --bold "How would you like to set your git identity?"
        echo
        echo "1. from the list"
        echo "2. manually"
        echo
        ansi --no-newline --bold "Your choice: "
        read -r choice
        echo

        case "${choice}" in
            1)
                if [[ ${#GIT_IDENTITY_LIST[*]} -eq 0 ]]; then
                    ansi --bold --color=${FMT_RED} "! No identity defined."
                    return 1
                fi

                for git_identity_index in $(seq 1 ${#GIT_IDENTITY_LIST[*]}); do
                    echo "${git_identity_index}. ${GIT_IDENTITY_LIST[${git_identity_index}]}"
                done

                echo
                ansi --no-newline --bold "Your choice: "
                read -r choice

                if [[ ${GIT_IDENTITY_LIST[${choice}]} == "" ]]; then
                    echo
                    ansi --bold --color=${FMT_RED} "! Invalid choice."
                    return 1
                fi

                git_user_name="$(echo "${GIT_IDENTITY_LIST[${choice}]}" | cut -d: -f1)"
                git_user_mail="$(echo "${GIT_IDENTITY_LIST[${choice}]}" | cut -d: -f2)"
                git_user_skey="$(echo "${GIT_IDENTITY_LIST[${choice}]}" | cut -d: -f3)"
            ;;

            2)
                ansi --no-newline --bold "What is your author name? "
                read -r git_user_name
                ansi --no-newline --bold "What is your author email? "
                read -r git_user_mail

                if is_installed "gpg"; then
                    echo
                    gpg --list-secret-keys --keyid-format LONG
                    ansi --no-newline --bold "What is your signing key ID (leave empty if don't want to set any)? "
                    read -r git_user_skey
                else
                    echo "GPG is not installed, not requesting signing key ID."
                fi

                if [[ "${git_user_name}" == "" ]] || [[ "${git_user_mail}" == "" ]]; then
                    echo
                    ansi --bold --color=${FMT_RED} "! Neither name nor email can be empty."
                    return 1
                fi
            ;;

            *)
                ansi --bold --color=${FMT_RED} "! Invalid choice."
                return 1
        esac

        if is_installed "gpg" && [[ "${git_user_skey}" != "" ]]; then
            gpg --list-key "${git_user_skey}" &> /dev/null
            rc=${?}

            if [[ ${rc} -ne 0 ]]; then
                echo
                ansi --bold --color=${FMT_RED} "! A key with ID ${git_user_skey} was not found."
                return 1
            fi

            git config commit.gpgsign true # autosign all commits/merges
            git config tag.forceSignAnnotated true # autosign all annotated tags
            git config user.signingkey "${git_user_skey}"
        else
            git config --unset commit.gpgsign
            git config --unset tag.forceSignAnnotated
            git config --unset user.signingkey
        fi

        git config user.name "${git_user_name}"
        git config user.email "${git_user_mail}"
        git config dotfiles.identity true

        local identity_string="${git_user_name} <${git_user_mail}>"

        if [[ "${git_user_skey}" != "" ]]; then
            identity_string+=" - sign key ID: ${git_user_skey}"
        fi

        echo
        ansi --color=${FMT_GREEN} "Git identity (${identity_string}) successfully set up."
    }

    function dotfiles_version() {
        echo

        previous_version_commit_id="$(git config --global --get dotfiles.oldversion)"

        if [[ "${previous_version_commit_id}" != "" ]]; then
            previous_version_tag="$(cd "${DOTFILES_ROOT}" >& /dev/null; git tag --points-at "${previous_version_commit_id}" -- | grep -E '^v[0-9]+(\.[0-9]+)+')"
            previous_version_datetime="$(cd "${DOTFILES_ROOT}" >& /dev/null; git show --no-patch --no-notes --pretty='%ad' --date="format:%d.%m.%Y %R" "${previous_version_commit_id}" --)"

            ansi --no-newline --bold --color=${FMT_ORANGE} "Previous version:"
            ansi --color=${FMT_ORANGE} " ${previous_version_tag:-${previous_version_commit_id}} (${previous_version_datetime})"
        fi

        current_version_commit_id="$(git config --global --get dotfiles.version)"
        current_version_tag="$(cd "${DOTFILES_ROOT}" >& /dev/null; git tag --points-at "${current_version_commit_id}" -- | grep -E '^v[0-9]+(\.[0-9]+)+')"
        current_version_datetime="$(cd "${DOTFILES_ROOT}" >& /dev/null; git show --no-patch --no-notes --pretty='%ad' --date="format:%d.%m.%Y %R" "${current_version_commit_id}" --)"

        echo -n " "
        ansi --no-newline --bold --color=${FMT_BLUE} "Current version:"
        ansi --color=${FMT_BLUE} " ${current_version_tag:-${current_version_commit_id}} (${current_version_datetime})"
    }

    # download gitignore for given os/ide/programming language
    function download_gitignore() {
        if [[ ${#} -eq 0 ]]; then
            >&2 echo "No os/ide/programming language given."
            return 1
        fi

        local content="$(curl -s "https://www.gitignore.io/api/${1}")"

        if [[ "${content}" =~ \#\!\!\ ERROR ]]; then
            >&2 echo "Unsupported os/ide/programming language."
            return 1
        fi

        echo "${content}"
    }

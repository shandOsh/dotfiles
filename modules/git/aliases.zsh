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
            local identity_string="${git_user_name} <${git_user_mail}>"

            if [[ "${git_user_skey}" != "" ]]; then
                identity_string+=" - sign key ID: ${git_user_skey}"
            fi

            echo
            format_message --newline --bold --color orange "You already have set up your git identity (${identity_string}). Continue anyway?"
            echo
            format_message --bold "Your choice (y/n): "
            read -r choice
            echo

            case "${choice}" in
                y)
                ;;

                n)
                    return 0
                ;;

                *)
                    format_message --newline --bold --color red "! Invalid choice."
                    return 1
            esac
        fi

        format_message --newline --bold "How would you like to set your git identity?"
        echo
        echo "1. from the list"
        echo "2. manually"
        echo
        format_message --bold "Your choice: "
        read -r choice
        echo

        case "${choice}" in
            1)
                if [[ ${#GIT_IDENTITY_LIST[*]} -eq 0 ]]; then
                    format_message --newline --bold --color red "! No identity defined."
                    return 1
                fi

                for git_identity_index in $(seq 1 ${#GIT_IDENTITY_LIST[*]}); do
                    echo "${git_identity_index}. ${GIT_IDENTITY_LIST[${git_identity_index}]}"
                done

                echo
                format_message --bold "Your choice: "
                read -r choice

                if [[ ${GIT_IDENTITY_LIST[${choice}]} == "" ]]; then
                    echo
                    format_message --newline --bold --color red "! Invalid choice."
                    return 1
                fi

                git_user_name="$(echo "${GIT_IDENTITY_LIST[${choice}]}" | cut -d: -f1)"
                git_user_mail="$(echo "${GIT_IDENTITY_LIST[${choice}]}" | cut -d: -f2)"
                git_user_skey="$(echo "${GIT_IDENTITY_LIST[${choice}]}" | cut -d: -f3)"
            ;;

            2)
                format_message --bold "What is your author name? "
                read -r git_user_name
                format_message --bold "What is your author email? "
                read -r git_user_mail

                if is_installed "gpg"; then
                    echo
                    gpg --list-secret-keys --keyid-format LONG
                    format_message --bold "What is your signing key ID (leave empty if don't want to set any)? "
                    read -r git_user_skey
                else
                    echo "GPG is not installed, not requesting signing key ID."
                fi

                if [[ "${git_user_name}" == "" ]] || [[ "${git_user_mail}" == "" ]]; then
                    echo
                    format_message --newline --bold --color red "! Neither name nor email can be empty."
                    return 1
                fi
            ;;

            *)
                format_message --newline --bold --color red "! Invalid choice."
                return 1
        esac

        if is_installed "gpg" && [[ "${git_user_skey}" != "" ]]; then
            gpg --list-key "${git_user_skey}" &> /dev/null
            rc=${?}

            if [[ ${rc} -ne 0 ]]; then
                echo
                format_message --newline --bold --color red "! A key with ID ${git_user_skey} was not found."
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
        format_message --newline --color green "Git identity (${identity_string}) successfully set up."
    }

    function dotfiles_version() {
        echo

        previous_version_commit_id="$(git config --global --get dotfiles.oldversion)"

        if [[ "${previous_version_commit_id}" != "" ]]; then
            previous_version_tag="$(cd "${DOTFILES_ROOT}" >& /dev/null; git tag --contains "${previous_version_commit_id}" --)"
            previous_version_datetime="$(cd "${DOTFILES_ROOT}" >& /dev/null; git show --no-patch --no-notes --pretty='%ad' --date="format:%d.%m.%Y %R" "${previous_version_commit_id}" --)"

            format_message --bold --color orange "Previous version:"
            format_message --newline --color orange " ${previous_version_tag:-${previous_version_commit_id}} (${previous_version_datetime})"
        fi

        current_version_commit_id="$(git config --global --get dotfiles.version)"
        current_version_tag="$(cd "${DOTFILES_ROOT}" >& /dev/null; git tag --contains "${current_version_commit_id}" --)"
        current_version_datetime="$(cd "${DOTFILES_ROOT}" >& /dev/null; git show --no-patch --no-notes --pretty='%ad' --date="format:%d.%m.%Y %R" "${current_version_commit_id}" --)"

        echo -n " "
        format_message --bold --color blue "Current version:"
        format_message --newline --color blue " ${current_version_tag:-${current_version_commit_id}} (${current_version_datetime})"
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

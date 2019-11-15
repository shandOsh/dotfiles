#   -------------------------------
#   7.  PROMPT
#   -------------------------------

    function dotfiles_prompt_git() {
        if [[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" != "true" ]]; then
            return
        fi

        echo -n "${DOTFILES_PROMPT_COMPONENT_LEFT}"

        # ___ git identity ___
        local identity_set_with_dotfiles="$(git config --local dotfiles.identity)"
        local git_user_name="$(git config --local user.name)"
        local git_user_skey="$(git config --local user.signingkey)"

        if [[ "${identity_set_with_dotfiles}" != "true" ]] || [[ "${git_user_name}" == "" ]]; then
            ansi --no-newline --bold --color=${FMT_RED} "!!! identity not set !!!"
        else
            ansi --no-newline --bold --color=${FMT_BLUE} "${git_user_name}"

            if [[ "${git_user_skey}" != "" ]]; then
                ansi --no-newline --bold --color=${FMT_GREEN} "\xE2\x9C\x94"
            fi
        fi

        echo -n " on "

        # ___ current branch ___
        local current_branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"

        if [[ "${current_branch}" == "" ]]; then
            ansi --no-newline --bold --color=${FMT_RED} "!!! unknown branch !!!"
        else
            ansi --no-newline --bold --color=${FMT_GREEN} "${current_branch}"
        fi

        echo -n "${DOTFILES_PROMPT_COMPONENT_RIGHT}"
    }

    prompt_component_append '$(dotfiles_prompt_git)'
    prompt_generate

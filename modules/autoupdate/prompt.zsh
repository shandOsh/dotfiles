#   -------------------------------
#   7.  PROMPT
#   -------------------------------

    function dotfiles_prompt_autoupdate_status() {
        if [[ ! -e "${DOTFILES_ROOT}/.dot_update" ]]; then
            return
        fi

        echo -n "${DOTFILES_PROMPT_COMPONENT_LEFT}"
        format_message --prompt --bold --color red "!!! update failed !!!"
        echo -n "${DOTFILES_PROMPT_COMPONENT_RIGHT}"
    }

    prompt_component_append '$(dotfiles_prompt_autoupdate_status)'
    prompt_generate

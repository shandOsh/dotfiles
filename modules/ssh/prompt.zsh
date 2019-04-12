#   -------------------------------
#   7.  PROMPT
#   -------------------------------

    function dotfiles_prompt_ssh() {
        if ! ssh-add -l &> /dev/null; then
            echo -n "${DOTFILES_PROMPT_COMPONENT_LEFT}"
            format_message --prompt --bold --color red "no ssh keys"
            echo -n "${DOTFILES_PROMPT_COMPONENT_RIGHT}"
        fi
    }

    prompt_component_append '$(dotfiles_prompt_ssh)'
    prompt_generate

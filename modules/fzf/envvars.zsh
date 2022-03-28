#   -------------------------------
#   2.  ENVIRONMENT CONFIGURATION
#   -------------------------------

    # TODO: somehow get rid of running subshell to find out if dark mode is active
    FZF_BAT_THEME="\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)"

    FZF_BIND_LIST=()
    FZF_BIND_LIST+=( "f2:toggle-preview" )
    FZF_BIND_LIST+=( "ctrl-d:half-page-down" )
    FZF_BIND_LIST+=( "ctrl-u:half-page-up" )
    FZF_BIND_LIST+=( "ctrl-a:select-all+accept" )
    FZF_BIND_LIST+=( "ctrl-y:execute-silent(echo {+} | pbcopy)" )
    FZF_BIND_LIST+=( "ctrl-g:preview-up" )
    FZF_BIND_LIST+=( "ctrl-f:preview-down" )
    # FZF_BIND_LIST+=( "ctrl-shift-g:preview-page-up" ) # doesn't work
    # FZF_BIND_LIST+=( "ctrl-shift-f:preview-page-down" ) # doesn't work

    FZF_DEFAULT_OPTS=""
    FZF_DEFAULT_OPTS+=" --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always --theme=${FZF_BAT_THEME} {} || cat {}) 2> /dev/null | head -300'"
    FZF_DEFAULT_OPTS+=" --preview-window='right'"
    FZF_DEFAULT_OPTS+=" --bind='$(IFS=,; printf '%s' "${FZF_BIND_LIST[*]}")'"

    export FZF_DEFAULT_OPTS

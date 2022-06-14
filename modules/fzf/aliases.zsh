#   -----------------------------
#   4.  ALIASES
#   -----------------------------

    # since it uses envvars, it doesn't change when the theme is changed, using alias instead
    fzf () { command fzf "${@}" --color="$(__fzf_get_format)"; }

#   -----------------------------
#   5.  FUNCTIONS
#   -----------------------------

    function __fzf_get_format() {
        # reload colors first
        load_theme_colors

        FZF_FORMAT_LIST=()
        FZF_FORMAT_LIST+=( "fg:${DOTFILES_THEME_FG}" )
        FZF_FORMAT_LIST+=( "bg:${DOTFILES_THEME_BG}" )
        FZF_FORMAT_LIST+=( "preview-bg:${DOTFILES_THEME_BG}" )
        FZF_FORMAT_LIST+=( "fg+:${DOTFILES_THEME_PRIMARY_FG}:regular" )
        FZF_FORMAT_LIST+=( "bg+:${DOTFILES_THEME_PRIMARY_BG}" )
        FZF_FORMAT_LIST+=( "gutter:${DOTFILES_THEME_BG}" )
        FZF_FORMAT_LIST+=( "border:${DOTFILES_THEME_TERTIARY_BG}" )
        FZF_FORMAT_LIST+=( "pointer:${DOTFILES_THEME_BG}:regular" )
        FZF_FORMAT_LIST+=( "marker:${DOTFILES_THEME_PRIMARY_BG}" )
        FZF_FORMAT_LIST+=( "prompt:${DOTFILES_THEME_SECONDARY_BG}:bold" )
        FZF_FORMAT_LIST+=( "query:${DOTFILES_THEME_FG}:bold" )
        FZF_FORMAT_LIST+=( "hl:${DOTFILES_THEME_PRIMARY_BG}:bold" )
        FZF_FORMAT_LIST+=( "hl+:${DOTFILES_THEME_FG}:bold" ) # TODO: I don't like in light theme + not readable in dark theme
        FZF_FORMAT_LIST+=( "info:${DOTFILES_THEME_TERTIARY_BG}" )

        printf '%s' "$(IFS=,; printf '%s' "${FZF_FORMAT_LIST[*]}")"
    }

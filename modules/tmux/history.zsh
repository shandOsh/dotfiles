#   -----------------------------
#   6.  HISTORY
#   -----------------------------

    if ! is_installed "tmux"; then
        return
    fi

    # inside tmux?
    if [[ -z ${TMUX+x} ]]; then
        return
    fi

    export TMUX_HISTDIR="${HOME}/.zhist"

    if [[ ! -d "${TMUX_HISTDIR}" ]]; then
        mkdir "${TMUX_HISTDIR}"
    fi

    TMUX_SWP_ID="$(tmux display -pt "${TMUX_PANE:?}" '#{session_name}:#{window_index}:#{pane_index}')"

    echo "Recovering shell history for pane ID ${TMUX_SWP_ID}..."
    export HISTFILE="${TMUX_HISTDIR}/.zhistory_${TMUX_SWP_ID}"

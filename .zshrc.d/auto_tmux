# TMUX auto create sessions
tmuxsession=$(tmux list-sessions | grep -v "(attached)" | awk -F':' '{print $1}' | head -1)
if [ ! -z "$tmuxsession" ] ; then
    tmux attach -t "$tmuxsession" &> /dev/null
else
    if [[ ! $TERM =~ screen ]]; then
        tmux
    fi
fi

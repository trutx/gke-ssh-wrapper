# SSH wrapper for GKE
function ssh() {
    local INDEX
    local PARAMS
    local P
    local SSH_USER
    local NODE_NAME
    local IP
    # Arrays start at index 1 in zsh
    [[ ${SHELL} == "/bin/zsh" ]] && INDEX=1 || INDEX=0
    PARAMS=(${@})
    for P in "${PARAMS[@]}"; do
        [[ "${P}" =~ ^(.+@)?gke-.+-[a-z0-9]{8}-[a-z0-9]{4}$ ]] && {
            kubectl config current-context > /dev/null || return 1
            [[ "${P}" =~ ^.+@.+$ ]] && {
                SSH_USER=${P%@*}@
                NODE_NAME=${P#*@}
            } || {
                NODE_NAME=${P}
            }
            IP=$(kubectl get no "${NODE_NAME}" -o json | jq -r '.status.addresses[0].address')
            PARAMS[${INDEX}]="${SSH_USER}${IP}"
            break
        }
        let INDEX++
    done
    /usr/bin/ssh "${PARAMS[@]}"
}

_electrumx()
{
    local cur prev

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    case ${COMP_CWORD} in
        1)
            COMPREPLY=($(compgen -W "configure show" -- ${cur}))
            ;;
        2)
            case ${prev} in
                chain)
                    COMPREPLY=($(compgen -W "header headers estimatefee relayfee subscribe height" -- ${cur}))
                    ;;
                addr)
                    COMPREPLY=($(compgen -W "balance history mempool listunspent subscribe unsubscribe" -- ${cur}))
                    ;;
				tx)
					COMPREPLY=($(compgen -W "get get_pos" -- ${cur}))
					;;
				mempool)
					COMPREPLY=($(compgen -W "get_fh" -- ${cur}))	
					;;
				srv)
					COMPREPLY=($(compgen -W "banner donations features peers ping version" -- ${cur}))
					;;
            esac
            ;;
        *)
            COMPREPLY=()
            ;;
    esac
}

complete -F _electrumx electrumx

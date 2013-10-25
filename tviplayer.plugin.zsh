alias v1='cd ~/workspace/tviplayer'
alias v3='cd ~/workspace/iplayer'
alias bamboo='cd ~/workspace/bamboo'
alias nav='cd ~/workspace/tviplayernav'
alias sandbox='ssh root@192.168.192.10'
alias sandbox6='ssh developer@sandbox.bbc.co.uk'
alias fucking='sudo -E'
alias h\?='history | grep'

function reithproxies {
    case "$1" in
    on)
        proxy=http://www-cache.reith.bbc.co.uk:80
        git config --global http.proxy "${proxy}"
        git config --global https.proxy "${proxy}"
        ;;
    off)
        proxy=
        git config --global --unset http.proxy
        git config --global --unset https.proxy
        ;;
    *)
        echo "Usage: $0 <command>\n"
        echo "    on    Turn on reith proxies"
        echo "    off   Turn off reith proxies"
        exit
    esac

    export http_proxy=${proxy}
    export https_proxy=${proxy}
    export HTTP_PROXY=${proxy}
    export HTTPS_PROXY=${proxy}
    export proxy=${proxy}

    echo "Proxies set to:"
    echo "\e[1;37m\"${proxy}\"\e[0m"
}

function sass_compile {
    if [ $1 ]; then
        cd ~/workspace/tviplayer/webapp/static-versioned
        sheet="$1"
        sass --scss --compass --update sass/stylesheets/${sheet}:style/stylesheets/${sheet}
        cd - > /dev/null
    fi
}

function gin {
    case "$1" in
    sync)
        BRANCH=`git symbolic-ref --short -q HEAD`
        git stash
        git checkout develop
        git fetch upstream && git rebase upstream/develop
        git checkout $BRANCH
        git rebase develop
        git stash pop
        echo "\e[1;37m"
        read -q "REPLY?Push to origin?"
        echo "\e[0m"
        case $REPLY in
            [Yy]*)
                git push origin $BRANCH --force
                ;;
            [Nn]*)
                ;;
        esac
        ;;
    delete)
        if [ $# -eq 2 ]; then
            echo "\e[1;37m"
            read -q "REPLY?Do you want to delete \"origin/$2\"?"
            echo "\e[0m"
            case $REPLY in
                [Yy]*)
                    git push origin :$2
                    ;;
                [Nn]*)
                    ;;
            esac
        else
            echo "Not enough arguments"
        fi
        ;;
    *)
        echo "Usage: $0 <command>\n"
        echo "    sync              Synchronise your code with upstream/develop"
        echo "    delete [branch]   Delete the [branch] in origin"
    esac
}

function _jiraa_sprint() {
    if [ $1 ]; then
        echo "Sprint $1"
        jiraa search "project = 'iPlayer (TV & iPlayer)' AND filter = $2 and status != Closed and sprint = 'Sprint $1' and issuetype not in (subTaskIssueTypes()) ORDER BY status ASC"
    else
        echo "Current sprint"
        jiraa search "project = 'iPlayer (TV & iPlayer)' AND filter = $2 and status != Closed and sprint in openSprints() and issuetype not in (subTaskIssueTypes()) ORDER BY status ASC"
    fi
}

function koalas {
    _jiraa_sprint "$1" Koalas
}
function wombats {
    _jiraa_sprint "$1" Wombats
}

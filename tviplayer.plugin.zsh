alias v1='cd ~/workspace/tviplayer'
alias v3='cd ~/workspace/iplayer'
alias bamboo='cd ~/workspace/bamboo'
alias nav='cd ~/workspace/tviplayernav'
alias sandbox='ssh root@192.168.192.10'
alias fucking='sudo -E'

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
                exit
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
                    exit
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
        exit
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

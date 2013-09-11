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

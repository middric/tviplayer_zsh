alias v1='cd ~/workspace/tviplayer'
alias v3='cd ~/workspace/iplayer'
alias bamboo='cd ~/workspace/bamboo'
alias nav='cd ~/workspace/tviplayernav'
alias sandbox='ssh root@192.168.192.10'
alias svs='svn st | grep "style/stylesheets" -v'
alias svd='svs | cut -b 3- | xargs svn diff'
alias svr='open "/Applications/Google Chrome.app" $(svd | revue)'
alias grr='open "/Applications/Google Chrome.app" $(git diff | revue)'
alias fucking='sudo -E'

function sass_compile {
    if [ $1 ]; then
        cd ~/workspace/tviplayer/webapp/static-versioned
        sheet="$1"
        sass --scss --compass -l -g --update sass/stylesheets/$sheet style/stylesheets/$sheet
        cd - > /dev/null
    fi
}

function gin() {
    message=$1
    branch=$(current_branch)
    git commit -m "${branch} ${message}"
}

function trunk {
    branch trunk
}

function branch {
    if [[ -d .svn ]]; then
        if [ $1 ]; then
            root=$(pwd | sed -n 's:^.*/::p')
            url=$(svn info | sed -n s/URL:\ //p 2>/dev/null)
            dir="$1"
            if [ $1 != "trunk" ]; then
                dir="branches/$1"
            fi
            branch=$(echo $url | sed -n 's:'"$root"'/.*$:'"$root"'/'"$dir"':p')
            if [ $branch ]; then
                svn switch $branch
            fi
        else
            echo "No branch defined"
        fi
    fi
}

function koalas {
    if [ $1 ]; then
        jiraa search "project = IPLAYER and component in ('iPlayer v3', 'Release Test', 'TV & iPlayer Automated Build', 'TV & iPlayer Channel Homepage', 'TV & iPlayer Favourites', 'TV & iPlayer Frameworks', 'TV & iPlayer Interactions', 'TV & iPlayer iPlayer Homepage', 'TV & iPlayer Navigation', 'TV & iPlayer Playlists', 'TV & iPlayer Search Results','TV & iPlayer TV Homepage') and status != Closed and fixVersion = 'Sprint $1' and issuetype not in (subTaskIssueTypes())"
    else
        echo "No sprint defined"
    fi
}

function pandas {
    if [ $1 ]; then
        jiraa search "project = IPLAYER and component in ('Mobile iPlayer','Release Test','TV & iPlayer Categories','TV & iPlayer Configuration','TV & iPlayer Help & FAQ ','TV & iPlayer MVT','TV & iPlayer Playback','TV & iPlayer TV Guide','TV - BBC Four Collection','TV - Comedy') and status != Closed and fixVersion ='Sprint $1' and issuetype not in (subTaskIssueTypes())"
    else
        echo "No sprint defined"
    fi
}

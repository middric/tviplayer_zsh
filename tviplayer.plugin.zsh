alias v1='cd ~/workspace/tviplayer'
alias v3='cd ~/workspace/iplayer'
alias sandbox='ssh root@192.168.192.10'
alias svs='svn st | grep "style/stylesheets" -v'
alias svd='svs | cut -b 3- | xargs svn diff'
alias svr='open "/Applications/Google Chrome.app" $(svd | revue)'

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

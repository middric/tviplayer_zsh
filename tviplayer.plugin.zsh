alias v1='cd ~/workspace/tviplayer'
alias v3='cd ~/workspace/iplayer'
alias sandbox='ssh root@192.168.192.10'
alias svs='svn st | grep "style/stylesheets" -v'
alias svd='svs | cut -b 3- | xargs svn diff'
alias svr='open "/Applications/Google Chrome.app" $(svd | revue)'
alias grr='open "/Applications/Google Chrome.app" $(git diff | revue)'
alias fucking='sudo -E'

function gin() {
    message=$1
    branch=$(current_branch)
    git commit -m "${branch} ${message}"
}

# The full svn URL
function svn_url {
    if [[ -d .svn ]]; then
        svn info | sed -n s/URL:\ //p
    fi
}

# The svn URL without trunk or branches
function svn_root {
    if [[ -d .svn ]]; then
        root=$(pwd | sed -n 's:^.*/::p')
        url=$(svn_url)
        branch=$(echo $url | sed -n 's:'"$root"'/.*$:'"$root"'/:p')
        echo $branch
    fi
}

# Create a branch and automatically switch to it
function create_branch {
    if [ $1 ]; then
        if [[ -d .svn ]]; then
            root=$(svn_root)
            branch_name=$1
            if [ $root ]; then
                trunk=${root}trunk
                branch=${root}branches/$1
                echo "svn copy $trunk $branch -m \"Creating branch $branch_name\""
                svn copy $trunk $branch -m "Creating branch $branch_name"
                echo "svn switch $branch"
                svn switch ${root}/branches/$1
            else
                echo "Couldn't determine SVN root URL"
            fi
        fi
    else
        echo "Please specify a branch name"
    fi
}

# Delete a branch - switches back to trunk if you're currently in the branch
function delete_branch {
    if [ $1 ]; then
        if [[ -d .svn ]]; then
            root=$(svn_root)
            branch_name=$1
            if [ $root ]; then
                branch = ${root}branches/$1
                echo "svn rm $branch -m \"Removing branch $branch_name\""
                svn rm $branch -m "Removing branch $branch_name"
                if [ $branch = $(svn_url) ]; then
                    trunk=${root}trunk
                    echo "svn switch $trunk"
                    svn switch $trunk
                fi
            else
                echo "Couldn't determine SVN root URL"
            fi
        fi
    else
        echo "Please specify a branch name"
    fi
}

# Synchronise current branch with trunk (Doesn't commit the changes)
function sync_branch {
    if [[ -d .svn ]]; then
        url=$(svn_url)
        if [[ $url =~ "branches" ]]; then
            echo "svn up"
            svn up
            trunk=$(svn_root)trunk
            echo "svn merge $trunk"
            svn merge $trunk
        else
            echo "Not in a branch, too risky!"
        fi
    fi
}

function trunk {
    branch trunk
}

function branch {
    if [[ -d .svn ]]; then
        if [ $1 ]; then
            root=$(pwd | sed -n 's:^.*/::p')
            url=$(svn_url)
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

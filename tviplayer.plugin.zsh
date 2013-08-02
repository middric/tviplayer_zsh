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
        sass --scss --compass --update sass/stylesheets/${sheet}:style/stylesheets/${sheet}
        cd - > /dev/null
    fi
}

function gin() {
    message=$1
    branch=$(current_branch)
    git commit -m "${branch} ${message}"
}

# The full svn URL
function _svn_url {
    if [[ -d .svn ]]; then
        svn info | sed -n s/URL:\ //p
    fi
}

# The svn URL without trunk or branches
function _svn_root {
    if [[ -d .svn ]]; then
        root=$(pwd | sed -n 's:^.*/::p')
        echo $(_svn_url) | sed -n 's:'"$root"'/.*$:'"$root"':p'
    fi
}

# Create a branch and automatically switch to it
function create_branch {
    branch_name=$1
    if [ $branch_name ]; then
        if [[ -d .svn ]]; then
            root=$(_svn_root)
            if [ $root ]; then
                trunk=${root}/trunk
                branch=${root}/branches/$branch_name
                svn copy $trunk $branch -m "Creating branch $branch_name"
                svn switch $branch
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
            root=$(_svn_root)
            branch_name=$1
            if [ $root ]; then
                branch=${root}/branches/$branch_name
                read -p "Are you sure? " -n 1 -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    svn rm $branch -m "Removing branch $branch_name"
                    if [ $branch = $(_svn_url) ]; then
                        trunk=${root}/trunk
                        svn switch $trunk
                    fi
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
function sync_with_trunk {
    if [[ -d .svn ]]; then
        url=$(_svn_url)
        if [[ $url =~ "branches" ]]; then
            svn up
            trunk=$(_svn_root)/trunk
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
            url=$(_svn_url)
            dir="$1"
            if [ $1 != "trunk" ]; then
                dir="branches/$1"
            fi
            branch=$(_svn_root)/$dir
            if [ $branch ]; then
                svn switch $branch
            fi
        else
            echo "No branch defined"
        fi
    fi
}

function _jiraa_sprint() {
    if [ $1 ]; then
        echo "Sprint $1"
        jiraa search "project = 'iPlayer (TV & iPlayer)' AND filter = $2 and status != Closed and sprint = 'Sprint $1' and issuetype not in (subTaskIssueTypes())"
    else
        echo "Current sprint"
        jiraa search "project = 'iPlayer (TV & iPlayer)' AND filter = $2 and status != Closed and sprint in openSprints() and issuetype not in (subTaskIssueTypes())"
    fi
}

function koalas {
    _jiraa_sprint "$1" Koalas
}
function wombats {
    _jiraa_sprint "$1" Wombats
}

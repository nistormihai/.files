re() {
    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi    
}

alias path='echo -e ${PATH//:/\\n}'
alias cd..='cdx ..'
cdx() {
    LIVEBLOG_PATH="liveblog"
    case $1 in
        lb)
            if [ -d "${LIVEBLOG_PATH}" ]; then
                cd ${LIVEBLOG_PATH}
            fi
            if [ -d "../../../../../${LIVEBLOG_PATH}" ]; then
                cd ../../../../
            fi
        ;;
        sd)
            if [ -d "${LIVEBLOG_PATH}" ]; then
                cd ${LIVEBLOG_PATH}
            fi

            if [ -d "./app/scripts/bower_components/superdesk/" ]; then
                cd ./app/scripts/bower_components/superdesk/
            fi
        ;;
        mocks)   cd $HOME/Documents/mocks/ ;;        
        *)    cd $1 ;;
    esac
}

rmx() {
    case $1 in
        dev) rm -rf dist/ server/ .tmp/ ;;
    esac
}


build() {
    if [ $# -gt 0 ]; then
        cdx $1
    fi
    if [ -f "Gruntfile.js" ] ; then
        grunt build --server=https://liveblog.sd-test.sourcefabric.org/api --ws=ws://liveblog.sd-test.sourcefabric.org/ws
    fi    
}

serv() {
    if [ $# -gt 0 ]; then
        cdx $1
    fi
    CURRENT=`pwd`
    if [[ $CURRENT == *"superdesk/client" ]] ; then
        grunt server --server=https://master.sd-test.sourcefabric.org/api --ws=ws://master.sd-test.sourcefabric.org/ws
    fi

    if [[ $CURRENT == *"liveblog/client" ]] ; then
        grunt server --server=https://liveblog.sd-test.sourcefabric.org/api --ws=ws://liveblog.sd-test.sourcefabric.org/ws
    fi
    if [ -f "server.js" ] ; then
        nodejs server.js
    fi
}

liveblog() {
    BOWER_PATH="app/scripts/bower_components"
    LIVEBLOG_PATH="liveblog"
    LIVEBLOG_BRANCH="master"
    SUPERDEKS_BRANCH="devel"
    SUPERDEKS_REPO="https://github.com/liveblog/superdesk-client.git#devel"
    MY_SUPERDEKS_REPO="git@github.com:nistormihai/superdesk-client.git"
    MY_SUPERDEKS_BOWER="${MY_SUPERDEKS_REPO}#${SUPERDEKS_BRANCH}"

    sudo npm update -g bower

    if [ -d "${LIVEBLOG_PATH}" ]; then
        cd ${LIVEBLOG_PATH}
    fi
    if [ -d "../${LIVEBLOG_PATH}" ]; then
        git checkout ${LIVEBLOG_BRANCH}
    else
        git clone git@github.com:nistormihai/liveblog-client.git --branch ${LIVEBLOG_BRANCH} ${LIVEBLOG_PATH}
        cd ${LIVEBLOG_PATH}
        git remote add liveblog https://github.com/superdesk/liveblog-client.git
        git remote add actionless https://github.com/actionless/liveblog-client.git
        git remote add vladnicoara https://github.com/vladnicoara/liveblog-client.git
        git remote add vied12 https://github.com/vied12/liveblog-client
    fi

    if [ ! -s "bower.swp" ] ; then
        mv bower.json bower.swp
    fi
    sed "s/${SUPERDEKS_REPO//\//\\/}/${MY_SUPERDEKS_BOWER//\//\\/}/g" bower.swp > bower.json
    npm install
    bower install
    cp bower.swp bower.json

    if [ -d "${BOWER_PATH}/superdesk/.git" ]; then
        PREV=`pwd`
        cd ${BOWER_PATH}/superdesk
        git checkout ${SUPERDEKS_BRANCH}
        cd ${PREV}
    else
        rm -r ${BOWER_PATH}/superdesk
        git clone ${MY_SUPERDEKS_REPO}  --branch ${SUPERDEKS_BRANCH} ${BOWER_PATH}/superdesk
        PREV=`pwd`
        cd ${BOWER_PATH}/superdesk        
        git remote add superdesk https://github.com/superdesk/superdesk-client.git
        git remote add liveblog https://github.com/liveblog/superdesk-client.git
        git remote add actionless https://github.com/actionless/superdesk-client.git
        git remote add vladnicoara https://github.com/vladnicoara/superdesk-client.git
        cd ${PREV}        
    fi
    PREV=`pwd`
    cd ${BOWER_PATH}/superdesk
    npm install
    bower install
    cd ${PREV}
}

test() {
    while getopts ":a:p:" opt; do
      case $opt in
        l) LIVEBLOG_BRANCH="$OPTARG"
        ;;
        s) SUPERDEKS_BRANCH="$OPTARG"
        ;;
        \?) echo "Invalid option -$OPTARG" >&2
        ;;
      esac
    done
    echo "name: ${LIVEBLOG_BRANCH}"
}

create() {
    if [ "$1" == "lb" ]; then
        git clone git@github.com:nistormihai/liveblog-client.git
        cd liveblog-client
        git remote add liveblog https://github.com/superdesk/liveblog-client.git
        git remote add actionless https://github.com/actionless/liveblog-client.git
        git remote add vladnicoara https://github.com/vladnicoara/liveblog-client.git
        sudo npm update -g bower
        npm install
        bower install
    fi
    if [ "$1" == "sd" ]; then
        git clone git@github.com:nistormihai/superdesk-client.git
        cd superdesk-client
        git remote add superdesk https://github.com/superdesk/superdesk-client.git
        git remote add liveblog git@github.com:liveblog/superdesk-client.git
        git remote add petrjasek https://github.com/petrjasek/superdesk-client.git
        git remote add vladnicoara https://github.com/vladnicoara/superdesk-client.git
        sudo npm update -g bower
        npm install
        bower install
    fi
}

update_lb() {
    git remote add plugin-liveblog-embed-server git@github.com:liveblog/plugin-liveblog-embed-server.git
    git fetch plugin-liveblog-embed-server
    git subtree pull --prefix=plugins/embed plugin-liveblog-embed-server master --squash
    git push
} 
re() {
    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi    
}

alias path='echo -e ${PATH//:/\\n}'
alias cd..='cd ..'

cls() {
    case $1 in
        lb)
            curl -XDELETE localhost:9200/liveblog
            mongo liveblog --eval "db.dropDatabase()"
            ;;
        *)
            clear
            ;;
    esac
}

adg() {
   case $1 in
        *)
            python3 manage.py users:create -u admin -p admin -e "admin@example.com" --admin=true
            ;;
    esac
}

serv() {
    CURRENT=`pwd`
    if [[ $CURRENT == *"superdesk/client" ]] ; then
        grunt server --server=https://master.sd-test.sourcefabric.org/api --ws=ws://master.sd-test.sourcefabric.org/ws
    fi

    if echo $CURRENT | grep -Eq 'liveblog([-a-zA-Z\_])*/client'; then
        if ! type grunt > /dev/null; then
            sudo npm install -g grunt-cli
        fi
        if [ ! -d "node_modules" ] ; then
            npm install
        fi
        if [ ! -d "app/scripts/bower_components" ] ; then
            bower install
        fi
        grunt server --server=http://localhost:5000/api
    fi

    if echo $CURRENT | grep -Eq 'liveblog([-a-zA-Z\_])*/server'; then
        if [ ! -d "env" ]; then
            virtualenv -p python3 env
            . env/bin/activate
            pip install -r requirements.txt
        else
            . env/bin/activate
        fi
        cls lb        
        adg lb
        honcho start
    fi
    
    if [ -f "server.js" ] ; then
        nodejs server.js
    fi
}


crt() {
    if [ "$1" == "lb" ]; then
        git clone git@github.com:nistormihai/liveblog.git
        git remote add liveblog https://github.com/superdesk/liveblog.git
        konsole --new-tab
        cd client 
        serv
        bower install
    fi
}

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
            mongo superdesk --eval "db.dropDatabase()"
            mongo local --eval "db.dropDatabase()"
            ;;
        *)
            clear
            ;;
    esac
}

adg() {
   case $1 in
        lb)
#            python manage.py roles:create -name editor
#            python manage.py roles:create -name contributor
            python3 manage.py users:create -u admin -p admin -e "admin@example.com" --admin=true
            python3 manage.py register_local_themes
            ;;
        themes)
            python3 manage.py register_local_themes
            ;;
    esac
}

serv() {
    CURRENT=`pwd`
    if [[ $CURRENT == *"superdesk/client" ]] ; then
        grunt server --server=http://localhost:5000/api
    fi

    if echo $CURRENT | grep -Eq 'superdesk([-a-zA-Z\_0-9])*/server'; then
        export SUPERDESK_TESTING=true
        if [ ! -d "env" ]; then
            virtualenv -p python3 env
            . env/bin/activate
            pip install -r requirements.txt
        else
            . env/bin/activate
        fi
        if [ "$1" == "cls" ]; then
        printf "\nClear databases!\n"
            cls lb
            adg lb
        fi
        honcho start
    fi

    if echo $CURRENT | grep -Eq 'liveblog([-a-zA-Z\_0-9])*/client'; then
        if ! type grunt > /dev/null; then
            sudo npm install -g grunt-cli
        fi
        if [ ! -d "node_modules" ] ; then
            npm install
        fi
        if [ ! -d "app/scripts/bower_components" ] ; then
            bower install
        fi
        grunt server --server=http://localhost:5000/api --embedly-key=82645d4daa7742cc891c21506d28235e --debug-mode=true
    fi

    if echo $CURRENT | grep -Eq 'liveblog([-a-zA-Z\_0-9])*/server'; then
        export SUPERDESK_TESTING=true
        if [ ! -d "env" ]; then
            virtualenv -p python3 env
            . env/bin/activate
            pip install -r requirements.txt
        else
            . env/bin/activate
        fi
        if [ "$1" == "cls" ]; then
        printf "\nClear databases!\n"
            cls lb
            adg lb
        fi
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

new() {
    if [ "$1" == "lb" ]; then
        git clone git@github.com:superdesk/liveblog.git
        git update-index --assume-unchanged client/tasks/options/watch.js
    fi
}
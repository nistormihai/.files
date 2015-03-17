DIR=${PWD}

if [ -f "${HOME}/.gitconfig" ]; then
    rm ${HOME}/.gitconfig
fi
ln -s ${DIR}/.gitconfig ${HOME}/.gitconfig

if [ -f "${DIR}/.bash_aliases ${HOME}/.bash_aliases" ]; then
    rm ${DIR}/.bash_aliases ${HOME}/.bash_aliases
fi
ln -s ${DIR}/.bash_aliases ${HOME}/.bash_aliases

mkdir -p ${HOME}/.config/doublecmd
if [ -f "${DIR}/.config/doublecmd/doublecmd.xml ${HOME}/.config/doublecmd/doublecmd.xml" ]; then
    rm -s ${DIR}/.config/doublecmd/doublecmd.xml ${HOME}/.config/doublecmd/doublecmd.xml
fi
ln -s ${DIR}/.config/doublecmd/doublecmd.xml ${HOME}/.config/doublecmd/doublecmd.xml
IFS=$'\n'
if [ ! -d "${HOME}/.config/sublime-text-3" ]; then
	mkdir -p ${HOME}/.config/sublime-text-3/Packages/User
fi
for file in `ls "${DIR}/.config/sublime-text-3/Packages/User"`; do
    if [ -f "${HOME}/.config/sublime-text-3/Packages/User/${file}" ]; then
        rm "${HOME}/.config/sublime-text-3/Packages/User/${file}"
    fi
    ln -s "${DIR}/.config/sublime-text-3/Packages/User/${file}" "${HOME}/.config/sublime-text-3/Packages/User/${file}"
done

rm -rf "${HOME}/.config/sublime-text-3/Installed Packages"
ln -s "${DIR}/.config/sublime-text-3/Installed Packages" "${HOME}/.config/sublime-text-3/Installed Packages"

all: clean
	ln -s ${HOME}/dotfiles/vimrc ${HOME}/.vimrc
	ln -s ${HOME}/dotfiles/gitignore ${HOME}/.gitignore
	ln -s ${HOME}/dotfiles/gitconfig ${HOME}/.gitconfig
	ln -s ${HOME}/dotfiles/tmux.conf ${HOME}/.tmux.conf
	ln -s ${HOME}/dotfiles/bashrc ${HOME}/.bashrc
	ln -s ${HOME}/dotfiles/bash_profile ${HOME}/.bash_profile
	mkdir -p ${HOME}/.config/pip
	ln -s ${HOME}/dotfiles/pip.conf ${HOME}/.config/pip/pip.conf
	[[ -f ${HOME}/.bash_aliases ]] || ln -s ${HOME}/dotfiles/bash_aliases ${HOME}/.bash_aliases

clean:
	rm -rf ${HOME}/.vimrc
	rm -rf ${HOME}/.gitignore
	rm -rf ${HOME}/.gitconfig
	rm -rf ${HOME}/.tmux.conf
	rm -rf ${HOME}/.bashrc
	rm -rf ${HOME}/.bash_profile
	rm -rf ${HOME}/.config/pip/pip.conf

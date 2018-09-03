all: clean
	ln -s ${HOME}/dotfiles/vimrc ${HOME}/.vimrc
	ln -s ${HOME}/dotfiles/gitignore ${HOME}/.gitignore
	ln -s ${HOME}/dotfiles/tmux.conf ${HOME}/.tmux.conf
	ln -s ${HOME}/dotfiles/bashrc ${HOME}/.bashrc
	mkdir -p ${HOME}/.config/pip
	ln -s ${HOME}/dotfiles/pip.conf ${HOME}/.config/pip/pip.conf

clean:
	rm -rf ${HOME}/.vimrc
	rm -rf ${HOME}/.gitignore
	rm -rf ${HOME}/.tmux.conf
	rm -rf ${HOME}/.bashrc
	rm -rf ${HOME}/.config/pip/pip.conf

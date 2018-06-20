all: clean
	ln -s ${HOME}/.dotfiles/vimrc ${HOME}/.vimrc
	ln -s ${HOME}/.dotfiles/gitignore ${HOME}/.gitignore
	ln -s ${HOME}/.dotfiles/tmux.conf ${HOME}/.tmux.conf

clean:
	rm -rf ${HOME}/.vimrc
	rm -rf ${HOME}/.gitignore
	rm -rf ${HOME}/.tmux.conf

all: clean
	ln -s ${HOME}/.dotfiles/vimrc ${HOME}/.vimrc
	ln -s ${HOME}/.dotfiles/gitignore ${HOME}/.gitignore

clean:
	rm -rf ${HOME}/.vimrc
	rm -rf ${HOME}/.gitignore

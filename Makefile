all: clean
	ln -s ${HOME}/.dotfiles/vimrc ${HOME}/.vimrc

clean:
	rm -rf ${HOME}/.vimrc

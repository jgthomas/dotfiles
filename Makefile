all: clean
	ln -s ${HOME}/dotfiles/vimrc ${HOME}/.vimrc
	ln -s ${HOME}/dotfiles/gitignore ${HOME}/.gitignore
	ln -s ${HOME}/dotfiles/gitconfig ${HOME}/.gitconfig
	ln -s ${HOME}/dotfiles/tmux.conf ${HOME}/.tmux.conf
	ln -s ${HOME}/dotfiles/bashrc ${HOME}/.bashrc
	ln -s ${HOME}/dotfiles/Xdefaults ${HOME}/.Xdefaults
	ln -s ${HOME}/dotfiles/xinitrc ${HOME}/.xinitrc
	ln -s ${HOME}/dotfiles/bash_profile ${HOME}/.bash_profile
	mkdir -p ${HOME}/.config/pip
	ln -s ${HOME}/dotfiles/pip.conf ${HOME}/.config/pip/pip.conf
	mkdir -p ${HOME}/.config/fontconfig
	ln -s ${HOME}/dotfiles/fonts.conf ${HOME}/.config/fontconfig/fonts.conf

clean:
	rm -rf ${HOME}/.vimrc
	rm -rf ${HOME}/.gitignore
	rm -rf ${HOME}/.gitconfig
	rm -rf ${HOME}/.tmux.conf
	rm -rf ${HOME}/.bashrc
	rm -rf ${HOME}/.Xdefaults
	rm -rf ${HOME}/.xinitrc
	rm -rf ${HOME}/.bash_profile
	rm -rf ${HOME}/.config/pip/pip.conf
	rm -rf ${HOME}/.config/fontconfig/fonts.conf

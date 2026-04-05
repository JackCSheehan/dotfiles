# Deploy dotfiles on a GNU/Linux system.
cp .vimrc ~/.vimrc
cp -r .vim ~/
cp .bashrc ~/.bashrc
cp .emacs ~/.emacs
cat gnome-custom-keybindings.conf | dconf load /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/
cat gnome-wm-keybindings.conf | dconf load /org/gnome/desktop/wm/keybindings/

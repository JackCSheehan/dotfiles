:: Deploy dotfiles on Windows.
xcopy .vimrc C:\Users\%USERNAME%
xcopy .vim C:\Users\%USERNAME% /S
xcopy .bashrc C:\Users\%USERNAME%

:: Be sure to set %HOME% to this path otherwise Emacs for Windows won't look here.
xcopy .emacs C:\Users\%USERNAME%

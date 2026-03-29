;; General editor settings.
(load-theme 'deeper-blue)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(save-place-mode +1)
(savehist-mode 1)
(column-number-mode +1)
(fringe-mode -1)
(global-auto-revert-mode 1)
(recentf-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq-default history-length 50)
(setq-default inhibit-startup-screen t)
(setq-default initial-scratch-message nil)
(setq-default use-file-dialog nil)
(setq-default use-dialog-box nil)
(setq-default make-backup-files nil)
(setq-default ring-bell-function 'ignore)
(setq-default blink-matching-paren nil)
(setq-default show-paren-delay 0)
(setq-default comment-multi-line t)
(show-paren-mode 1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(global-set-key (kbd "RET") (key-binding (kbd "M-j")))

;; Grep
(setopt grep-command "grep -irn ")
(global-set-key (kbd "C-c g") 'grep)

;; Find
(global-set-key (kbd "C-c f") 'find-lisp-find-dired)

;; Line numbers
(global-display-line-numbers-mode 1)
(setq-default display-line-numbers-type 'relative)

;; Indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default indent-line-function 'insert-tab)
(setq-default backward-delete-char-untabify-method 'all)

;; Tab bar settings.
(setq-default tab-bar-close-button-show nil)
(setq-default tab-bar-new-button-show nil)

;; Cross-platform things.
(when (eq system-type 'windows-nt)
    (setq-default explicit-shell-file-name "powershell"))
(when (eq system-type 'gnu/linux)
    (setq-default explicit-shell-file-name "bash"))

;; Terminals.
(add-hook 'term-mode-hook (lambda () (term-set-escape-char ?\C-x)))
(setq-default confirm-kill-processes nil)

;; Window and terminal splits.
(global-set-key (kbd "C-x 3") (lambda () (interactive) (split-window-right) (other-window 1)))
(global-set-key (kbd "C-x 2") (lambda () (interactive) (split-window-below) (other-window 1)))
(global-set-key (kbd "C-c t") (lambda() (interactive) (ansi-term explicit-shell-file-name)))

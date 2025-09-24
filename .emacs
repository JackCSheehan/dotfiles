;; General editor settings.
(load-theme 'tango-dark)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(save-place-mode +1)
(column-number-mode +1)
(global-auto-revert-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq-default inhibit-startup-screen t)
(setq-default initial-scratch-message nil)
(setq-default use-file-dialog nil)
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

;; Viper
(setq-default viper-inhibit-startup-message 't)
(setq-default viper-expert-level '5)
(setq-default viper-mode t)
(setq-default viper-shift-width 4)
(setq-default viper-ex-style-motion nil)
(setq-default viper-ex-style-editing nil)
(require 'viper)

;; Terminals
(add-hook 'term-mode-hook (lambda () (term-set-escape-char ?\C-x)))

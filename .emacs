;; General editor settings.
(load-theme 'tango-dark)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(save-place-mode +1)
(column-number-mode +1)
(setopt use-short-answers t)
(setq-default inhibit-startup-screen t)
(setq-default initial-scratch-message nil)
(setq-default use-file-dialog nil)
(setq-default make-backup-files nil)

;; Line numbers
(global-display-line-numbers-mode 1)
(setq-default display-line-numbers 'relative)

;; Indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default indent-line-function 'insert-tab)
(setq-default backward-delete-char-untabify-method 'all)

;; Viper mode
(setq-default viper-inhibit-startup-message 't)
(setq-default viper-expert-level '5)
(setq-default viper-mode t)
(require 'viper)

;; Terminals
(add-hook 'term-mode-hook (lambda () (term-set-escape-char ?\C-x)))


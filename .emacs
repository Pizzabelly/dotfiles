;; Very scuffed Emacs config.

;; Remove UI elements.
(if (fboundp 'menu-bar-mode)   (menu-bar-mode   -1))
(if (fboundp 'tool-bar-mode)   (tool-bar-mode   -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq inhibit-splash-screen t
      inhibit-startup-screen t
      inhibit-startup-message t)

(setq suggest-key-bindings nil)

(setq-default buffer-file-coding-system 'utf-8)
(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
(prefer-coding-system 'utf-8)

(set-face-attribute 'default nil
                    :family "APL385 Unicode"
                    :height 135
                    :weight 'normal)

(global-auto-revert-mode t)

(show-paren-mode 0)
(setq blink-matching-paren t)

;; Custom C style.
(c-add-style "c-style"
	         '("bsd"
	           (c-backspace-function . delete-backward-char)
	           (c-syntactic-indentation-in-macros . nil)
	           (c-tab-always-indent . nil)
	           (c-hanging-braces-alist
		        (block-close . c-snug-do-while))
	           (c-offsets-alist
		        (arglist-cont-nonempty . 4)
		        (statement-cont . *)
		        (access-label . -2))
	           (indent-tabs-mode . nil)
	           (c-offsets-alist . ((innamespace . [0])))))

(setq-default c-default-style "c-style"
	          c-basic-offset 4
              tab-width 4
              tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80)
	          indent-tabs-mode nil)

(require 'cc-mode)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))

(setq backup-directory-alist '(("." . "~/.emacs.d/saves")))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'colors-emacs t t)
(enable-theme 'colors-emacs)

(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives
               (cons "melpa" (concat proto "://melpa.org/packages/")) t))
(package-initialize)

(eval-when-compile
  (require 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package projectile
  :config
  (projectile-mode +1))

(use-package neotree
  :config
  (setq neo-smart-open t)
  (setq neo-theme 'ascii))

(use-package evil
  :init
  (setq evil-overriding-maps nil
	    evil-intercept-maps nil)
  :config
  (evil-mode 1)
  (setq evil-emacs-state-modes nil)
  (setq evil-insert-state-modes nil)
  (setq evil-motion-state-modes nil)
  (evil-set-command-property 'xref-find-definitions :jump t)
  (evil-set-command-property 'xref-find-references :jump t))

;; Disable prompt when hitting shift k.
(define-key evil-normal-state-map "K" 'ignore)
;; Disable help page keybind.
(define-key evil-normal-state-map (kbd "C-w") 'ignore)
;; Disable tab search.
(define-key evil-normal-state-map (kbd "<tab>") 'ignore)
;; Search.
(define-key evil-normal-state-map (kbd "C-i") 'rgrep)
;; Move through split windows.
(global-unset-key (kbd "C-h"))
(global-unset-key (kbd "C-l"))
(global-unset-key (kbd "C-k"))
(global-unset-key (kbd "C-j"))
(define-key evil-normal-state-map (kbd "C-h") 'windmove-left)
(define-key evil-normal-state-map (kbd "C-l") 'windmove-right)
(define-key evil-normal-state-map (kbd "C-k") 'windmove-up)
(define-key evil-normal-state-map (kbd "C-j") 'windmove-down)
;; Window split keybinds.
(define-key evil-normal-state-map (kbd "C-s") 'split-window-right)
(define-key evil-normal-state-map (kbd "C-S-s") 'split-window-vertically)
;; Neotree bindings.
(define-key evil-normal-state-map (kbd "T") 'neotree-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "<tab>") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
(evil-define-key 'normal neotree-mode-map (kbd "j") 'neotree-next-line)
(evil-define-key 'normal neotree-mode-map (kbd "k") 'neotree-previous-line)
(evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle)
;; Org Mode Evil.
(evil-define-key 'normal org-mode-map (kbd "<tab>") 'org-cycle)
(evil-define-key 'normal org-mode-map (kbd "SPC") 'org-toggle-checkbox)
;; Buffer back button.
(defun er-switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key (kbd "C-,") 'er-switch-to-previous-buffer)

(use-package org)

(use-package magit)

(use-package undo-tree
  :config
  (define-key evil-normal-state-map (kbd "C-r") 'undo-tree-redo)
  (define-key evil-normal-state-map (kbd "u") 'undo-tree-undo)
  (global-undo-tree-mode))

(use-package dashboard
  :ensure t
  :init
  (setq dashboard-image-banner-max-height 900)
  (setq dashboard-center-content t)
  (setq dashboard-banner-logo-title "")
  (setq dashboard-startup-banner "~/pics/emacs-start.png")
  (setq dashboard-items '((recents  . 6)))
  (setq dashboard-set-footer nil)
  :config
  (dashboard-setup-startup-hook))

(use-package company
  :init
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0)
  (setq company-selection-wrap-around t)
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (company-tng-configure-default))

(use-package rustic
  :init
  (setq rustic-lsp-client 'lsp-mode)
  (setq rustic-lsp-server 'rust-analyzer))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package lsp-mode
  :config
  (setq lsp-idle-delay 0.300)
  (setq lsp-enable-indentation nil)
  (setq lsp-enable-on-type-formatting nil)
  (add-hook 'c-mode-hook #'lsp)
  (add-hook 'c++-mode-hook #'lsp)
  (add-hook 'rustic-mode-hook #'lsp))

(use-package lsp-ui
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-flycheck-live-reporting nil)
  (setq lsp-ui-sideline-enable t
	    lsp-ui-sideline-show-symbol nil
	    lsp-ui-sideline-show-hover nil
	    lsp-ui-sideline-show-flycheck t
	    lsp-ui-sideline-show-code-actions nil
	    lsp-ui-sideline-show-diagnostics nil)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package flycheck
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (setq flycheck-checker 'lsp-ui))

(defun flymake--transform-mode-line-format (ret)
  (setf 'nil)
  ret)
(advice-add #'flymake--mode-line-format
            :filter-return #'flymake--transform-mode-line-format)

(require 'color)
(defun set-hl-line-color-based-on-theme ()
  (set-face-attribute 'hl-line nil
                      :foreground nil
                      :background (color-lighten-name (face-background 'default) 3)))
(add-hook 'global-hl-line-mode-hook 'set-hl-line-color-based-on-theme)
(global-hl-line-mode)

(load "~/.emacs.d/custom.el")


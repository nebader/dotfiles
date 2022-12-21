;; This init.el file is run by emacs when it first starts loading.
;;   This will eventually be a minimal configuration designed to set up package
;;   managers, enable org mode, then run emacs-config.org, where the
;;   rest of the configuration lives.
;; Nick Bader
;; Last updated: June 2022

;; -- Package management part 1: package.el --

; Load local file "package.el" to start built-in package manager
(require 'package)

; Change package.el 'archives' variable to add additional repositories
(setq package-archives '( 
	("melpa" . "https://melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages")
        ))

; Tell package.el to load packages in its load list
(package-initialize)

; Only update list of available packages if the list doesn't exist (new install)
(unless package-archive-contents ; evals to TRUE if list exists
  package-refresh-contents)      ; call this fxn to update manually

; Bootstrap use-package, a package that changes the way that packages
; are specified and loaded, and enables lazy loading
(unless (package-installed-p 'use-package) ; check if it is installed
  (package-refresh-contents)               ; call this fxn to update manually
  (package-install 'use-package))          ; install if missing
(require 'use-package)                     ; load use-package
;(setq use-package-always-ensure t)         ; installs missing pkgs (or do in each use-package)

; This package attempts to set emacs exec-path and PATH from the shell path
; Should work if your shell is found by (getenv "SHELL")
(use-package exec-path-from-shell
  :ensure t ; install if not installed already
  :if (memq window-system '(mac ns x)) ; when window mgr is either mac, ns, or x
  :config
  (exec-path-from-shell-initialize)
  )

; Turn on IDO mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; ; Use Evil mode (vim emulator)
;; ;; load evil
;; (use-package evil
;;   :ensure t ; install the evil package if not installed
;;   :defer .1 ; load emacs before loading evil
;;   :init     ; run before loading package:
;;   (setq evil-want-keybinding nil)  ; required by evil-collection
;;   (setq evil-search-module 'evil-search)
;;   ;(setq evil-ex-complete-emacs-commands nil)
;;   (setq evil-vsplit-window-right t) ; like vi splitright
;;   (setq evil-split-window-below t) ; like vi splitbelow
;;   ;(setq evil-shift-round nil)
;;   ;(setq evil-want-C-u-scroll t)
;;   :config ;; run after loading package:
;;   (evil-mode)
;;   ;; example how to map a command in normal mode (called 'normal state' in evil)
;;   ;(define-key evil-normal-state-map (kbd ", w") 'evil-window-vsplit)
;;   )

;; ;; vim-like keybindings everywhere in emacs
;; (use-package evil-collection
;;   :after evil
;;   :ensure t
;;   :config
;;   (evil-collection-init)
;;   )

;; ;; gc operator, like vim-commentary
;; (use-package evil-commentary
;;   :ensure t
;;   :bind (
;;     :map evil-normal-state-map("gc" . evil-commentary))
;;   )

; R interface
(use-package ess)

; LaTeX interface
(use-package latex
  :ensure auctex
  :config
  (setq-default TeX-master nil)
  )

; Editable inline LaTeX snippets in org
(use-package org-fragtog
  :ensure t
  )


;; Simplify the Emacs UI
(setq inhibit-startup-screen t) ; same as startup-message/splash-screen
(tool-bar-mode -1)              ; turn off the graphics buttons
(menu-bar-mode -1)              ; turn off the menu bar at the top
(scroll-bar-mode -1)            ; turn off the right-hand scrollbar
(tooltip-mode -1)               ; don't use tooltips on mouseover


;; Appearance
(set-face-attribute 'default nil :font "inconsolata" :height 200) ; font
(load-theme 'misterioso) ; theme
(add-to-list 'initial-frame-alist '(fullscreen . maximized)) ; start in big window

; Mode line changes
;(use-package doom-modeline
;  :ensure t
;  :init (doom-modeline-mode 1))


;; - Housecleaning -

;; Have Customize write its customization settings to another file,
(setq custom-file "~/.emacs.d/custom-file.el")
(load custom-file)

;; Keep backup files (file~) out of my directories
(setq backup-directory-alist
        '(("." . "~/.saves" )) ; Put all backups in .saves
      backup-by-copying t      ; don't mess up symlinks
      delete-old-versions t    ; don't let old versions pile up
      kept-new-versions 6      
      kept-old-versions 2
      version-control t)       ; use versioned backups

;; - Global behavior -

;; On Mac, make sure that option is meta, not command (I switched keys globally)
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta
	mac-command-modifier 'nil))
;	mac-option-modifier 'meta
;        mac-right-option-modifier 'nil
;	mac-command-modifier 'nil
;	mac-right-command-modifier 'meta))

;; - Interaction with system clipboard
(setq-default
 ;; Kill and yank use the system clipboard
 select-enable-clipboard t
 ;; Kill and yank also uses the X primary selection, just in case
 select-enable-primary t
 ;; Save clipboard strings into kill ring before replacing them.  With this
 ;; off, if you copy something outside emacs, then kill in emacs, then the
 ;; external selection is gone.
 save-interprogram-paste-before-kill t
)

;; Automatically update buffers if file content on the disk has changed.
(setq global-auto-revert-mode t)

;; When searching using apropos in Emacs help, show all hits,
;; not just user-defined
(setq apropos-do-all t)
  

(setq-default
;; Display column number in mode line.
 column-number-mode t
)

; Relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)


 
;; Org behavior
(add-hook 'org-mode-hook 'org-fragtog-mode)
(add-hook 'org-mode-hook (lambda () (plist-put org-format-latex-options :scale 1.8)))
(org-babel-do-load-languages
  'org-babel-load-languages
  '(
    (R . t)
    (python . t)
    (maxima . t)
    (latex . t)
    ))
;; Syntax highlight in #+BEGIN_SRC blocks
(setq org-src-fontify-natively t)
;; Don't prompt before running code in org
(setq org-confirm-babel-evaluate nil)
;; Fix an incompatibility between the ob-async and ob-ipython packages
;(setq ob-async-no-async-languages-alist '("ipython"))


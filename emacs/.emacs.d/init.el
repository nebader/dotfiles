;; This init.el file is run by emacs when it first starts loading.
;;   This will eventually be a minimal configuration designed to set up package
;;   managers, enable org mode, then run emacs-config.org, where the
;;   rest of the configuration will live.
;; Nick Bader
;; Last updated: May 2023
;; System Crafters 1: UI, package manager, completion framework

;; -- Package management --

; Load local file "package.el" to enable package mgmt functions
(require 'package)

; Change package.el 'archives' variable to add additional repositories
(setq package-archives '(
			 ("melpa" . "https://melpa.org/packages/")			 
			 ("gnu" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ))

; Tell package.el to load packages in its load list
(package-initialize)

; Only update list of available packages if the list doesn't exist (new install)
(unless package-archive-contents ; evals to TRUE if list exists
  package-refresh-contents)
; Current problem: if you installed emacs a while ago, then try to install a package,
; use-package will "fail to install" because the list is outdated.  You can run
; M-x package-refresh-contents manually if you see this error message.
; In the long term, moving to straght.el might be the way to fix this.

; Bootstrap use-package, a package that changes the way that packages
; are specified and loaded, and enables lazy loading
(unless (package-installed-p 'use-package) ; check if it is installed
  (package-refresh-contents)               ; call this fxn to update manually
  (package-install 'use-package))          ; install if missing
(require 'use-package)                     ; load use-package
(setq use-package-always-ensure t)         ; installs missing pkgs (or do in each use-package)

; -- Completion framework --

; IDO mode
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (ido-mode 1)

; vertico displays candidates in a vertical list in the minibuffer
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode)
  )

; savehist ("saved history") is a built-in package that puts your recently-selected files at the top of the list.
;; (use-package savehist
;;   :init
;;   (savehist-mode)
;;   )

; orderless lets you enter space separated search terms for filtering
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Marginalia displays annotations in the minibuffer
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  ;; The :init section is always executed.
  :init
  ;; Marginalia must be actived in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package
  (marginalia-mode))

; ----------------------------- ;


; -- shell stuff?? --
; This package attempts to set emacs exec-path and PATH from the shell path
; Should work if your shell is found by executing (getenv "SHELL")
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x)) ; when window mgr is either mac, ns, or x
  :config
  (exec-path-from-shell-initialize)
  )


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

; git interface
(use-package magit
  :bind (("C-x g" . magit))
  )

; R interface
(use-package ess)

; LaTeX interface
(use-package latex
  :ensure auctex
  :config
  (setq-default TeX-master nil)
  )

; Editable inline LaTeX snippets in org
(use-package org-fragtog)


; ------------- Emacs UI ----------------


;; Simplify the Emacs UI
(setq inhibit-startup-screen t) ; "startup-screen" is same as "startup-message" and "splash-screen"
(tool-bar-mode -1)              ; turn off the graphical buttons
(menu-bar-mode -1)              ; turn off the menu bar at the top
(scroll-bar-mode -1)            ; turn off the right-hand scrollbar
(tooltip-mode -1)               ; don't use tooltips on mouseover
(set-fringe-mode 10)            ; (default is 8 pix) adds a little room on the right and left

;; Appearance
(set-face-attribute 'default nil :font "inconsolata" :height 200) ; font
(load-theme 'misterioso) ; theme
(add-to-list 'initial-frame-alist '(fullscreen . maximized)) ; start in big window

(setq help-at-pt-display-when-idle t) ; shows tooltips in minibuffer


; Mode line changes
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))


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
  (setq mac-command-key-is-meta t))
;  (setq mac-option-modifier 'meta
;	mac-command-modifier 'nil))
;	mac-option-modifier 'meta
;        mac-right-option-modifier 'nil
;	mac-command-modifier 'nil
;	mac-right-command-modifier 'meta))

; On Mac, command-h bypasses emacs to hide the window.  Prevent emacs from sending this
; command-tab still works as macos app switcher!
(setq mac-pass-command-to-system nil)

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


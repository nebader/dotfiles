;; This init.el file is run by emacs when it first starts loading.
;;   This will eventually be a minimal configuration designed to set up package
;;   managers, enable org mode, then run emacs-config.org, where the
;;   rest of the configuration will live.
;; Nick Bader
;; Last updated: May 2023
;; System Crafters 1: UI, package manager, completion framework

;; Note about LISP comment standards
;; Double ;; starts a comment on its own line, indented with code
					; Single is for comment suffix at col 40


;; TO DO
;; Selection c-=
;; Note any obsolete keybindings
;; M-m will be subsumed into C-a


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
; In the long term, moving to straight.el might be the way to fix this.

; Bootstrap use-package, a package that changes the way that packages
; are specified and loaded, and enables lazy loading
(unless (package-installed-p 'use-package) ; check if it is installed
  (package-refresh-contents)               ; call this fxn to update manually
  (package-install 'use-package))          ; install if missing
(require 'use-package)                     ; load use-package
(setq use-package-always-ensure t)         ; installs missing pkgs (do in each use-package)

; -- Completion framework --

; IDO mode - the bare-bones system (works fine)
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (ido-mode 1)

;; vertico displays candidates in a vertical list in the minibuffer,
;; which is a little easier to read
(use-package vertico
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

; orderless lets you enter space separated search terms for filtering candidates
(use-package orderless
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

;; helpful is a package that improves the help screens?

; -- shell stuff?? --
; This package attempts to set emacs exec-path and PATH from the shell path
; Should work if your shell is found by executing (getenv "SHELL")
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x)) ; when window mgr is either mac, ns, or x
  :config
  (exec-path-from-shell-initialize)
  )

;; ----------------- Evil mode stuff --------------------

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

;; ---------------- Project management: projectile and magit ----

;; Projectile makes extra commands available if it detects you are opening
;; a file from a folder with a git repo, and project file, etc.

;;
;; Two big commands are
;; C-p f projectile-find-file looks for a file in the current project using fuzzy matching
;; C-p p projectile-switch-project switches to another project if you're working
;; on more than one.  Below is set to open dired when you do this.
;; built-in alternative is project.el
(use-package projectile
  ;;  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired)
  )



;; git interface
;; use C-x g to pull it up
(use-package magit
  ;; :custom
  ;; (magit-display-buffer-function `magit-display-buffer-same-window-except-diff-v1)
  )

;;  :bind (("C-c g" . magit))

 
;; -----------------------------------------------------------

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

;; Note: on a new install you'll need to run the following interactively
;; or else some fonts won't be installed
;; M-x all-the-icons-install-fonts

(use-package all-the-icons
  :ensure t)

;; Simplify the Emacs UI
(setq inhibit-startup-screen t) ; "startup-screen" is same as "startup-message" and "splash-screen"
(tool-bar-mode -1)              ; turn off the graphical buttons
(menu-bar-mode -1)              ; turn off the menu bar at the top
(scroll-bar-mode -1)            ; turn off the right-hand scrollbar
(tooltip-mode -1)               ; don't use tooltips on mouseover
(set-fringe-mode 10)            ; (default is 8 pix) adds a little room on the right and left

;; Appearance
(set-face-attribute 'default nil :font "inconsolata" :height 200) ; font
;;(load-theme 'misterioso) ; theme
(add-to-list 'initial-frame-alist '(fullscreen . maximized)) ; start in big window

;; theme.  I like doom-tomorrow-day for a light screen.  there is also a doom-tomorrow-night but the comments are too dim
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-tomorrow-day t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


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

;; -------------------- User-defined functions and code ------------------

(defun nb/point-is-on-leading-symbol ()
  "Determine whether point is on a leading header, comment, or list item
Return t if so; nil otherwise.
For future, note that emacs has 'fill-prefix' including all comments
and some of the items below ('*', '-').  You can move past them with
the built-in command 'beginning-of-line-text'"
 (interactive) ; eventually delete this line
  (let ((start-pt (point)))
   (save-excursion
    (move-beginning-of-line nil)
    (and
     (looking-at (rx
      line-start
      (zero-or-more blank)
      (group-n 1 (or
       (one-or-more "*")   ; org headers
       (one-or-more "-"))) ; markdown list items
      (one-or-more blank)
      (one-or-more graphic)))
     (>= start-pt (match-beginning 1))
     (< start-pt (match-end 1))))))

(defun nb/move-end-of-line (prefix)
  "Move point to end of line; if repeated, delete trailing whitespace.
Moves point to the end of the line with universal PREFIX if not there already.
If point is at the end of the line, remove trailing whitespace,
moving point to last non-whitespace character.
Thus C-e C-e replaces C-e M-/ in vanilla emacs."
  (interactive "^p") ; p accepts numeric prefix from C-u; ^ extends selection
  ;; First, 'move-end-of-line' (with numeric prefix) and check if point moved.
  ;; If not, it's already at end of line so run 'delete-horizontal-space'
  (let ((start-point (point)))
    (move-end-of-line prefix)
    (when (= start-point (point))
      (delete-horizontal-space))))

(defun nb/move-beginning-of-line (prefix)
  "Toggle pt to line beginning, text after indentation/list element/comment.
Toggles point among three locations: beginning of line (as in the default),
the first non-whitespace character in the line (default M-m), and
the first non-whitespace character after a leading symbol, such as a markdown
list item, an org heading, a comment character, etc. Leading symbols are
defined in a separate function, 'nb/point-is-on-leading-symbol.'"
  (interactive "^p") ; p accepts numeric prefix from C-u; ^ extends selection
  (setq prefix (or prefix 1)) ; either nil or 1 is set to 1
  ;; If there is numeric prefix (not nil or 1), move down n-1 lines
  (cond ((/= prefix 1) (move-beginning-of-line prefix))
    ;; If pt is at beginning of line on whitespace char, move to 1st non-ws
    ((and (= (current-column) 0) (looking-at "[[:blank:]]"))
      (back-to-indentation))
    ;; Else if pt is on comment/list/header char, move to text after char
    ((nb/point-is-on-leading-symbol)
      (progn (forward-word nil) (backward-word nil)))
    ;; Otherwise go to the beginning of the line
    (t (move-beginning-of-line nil))))

;; future: look into general.el to define all your keybindings with nice syntax
;; more importantly, this is the way to spacemacs like leader keys etc.

;; Wow, hydra is really great, allowing you to simplify "families" of keybinds

;; remap C-e and C-a to my functions
(global-set-key (kbd "C-e") 'nb/move-end-of-line)
(global-set-key (kbd "C-a") 'nb/move-beginning-of-line)


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

;; Line numbers

;; (setq display-line-numbers-type 'relative)
(column-number-mode)
(global-display-line-numbers-mode t)
;; disable line numbers for some modes
;; change modes as necessary
(dolist (mode '(
	      shell-mode-hook
	     ;; term-mode-hook
	      org-mode-hook
	      eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; matching pairs of brackets/parens/etc. are colored the same
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; which-key displays possible subsequent keys after a prefix
(use-package which-key
  :init (which-key-mode)
  :diminish (which-key-mode)
  :config (setq which-key-idle-delay 0.3)) ; displays after short delay

 
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


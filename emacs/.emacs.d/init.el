;; Packages
(require 'package)
(package-initialize)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

;; Housecleaning

;; Have Customize write its stuff to another file,
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



;; ――――――――――――――――――――――――――――――――― Use better defaults ―――――――――――――――――――――――――――――――
(setq-default

 ;; Do not show the startup message.
 inhibit-startup-message t)

;; Make the command key behave as 'meta'
(when (eq system-type 'darwin)
  (setq mac-right-command-modifier 'meta))

;; Display column number in mode line.
(column-number-mode t)

;; Automatically update buffers if file content on the disk has changed.
(global-auto-revert-mode t)


;; ――――――――――――――――――――――――――― Disable unnecessary UI elements ―――――――――――――――――――――――――
(progn
  ;; Do not show menu bar.
  ;; (menu-bar-mode -1)

  ;; Do not show tool bar.
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))

  ;; Do not show scroll bar.
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

  ;; Highlight line on point.
  (global-hl-line-mode t))

;; ――――――――――――――――――――――――― Better interaction with system clipboard ―――――――――――――――――――――――――
(setq-default
 ;; Kill and yank use the system clipboard
 select-enable-clipboard t
 ;; Kill and yank also uses the X primary selection, just in case
 Select-enable-primary t

 ;; Save clipboard strings into kill ring before replacing them. When
 ;; one selects something in another program to paste it into Emacs, but
 ;; kills something in Emacs before actually pasting it, this selection
 ;; is gone unless this variable is non-nil.
 save-interprogram-paste-before-kill t

 ;; Shows all options when running apropos. For more info,
 ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Apropos.html.
 apropos-do-all t

 ;; Mouse yank commands yank at point instead of at click.
 mouse-yank-at-point t)

;; Set the default color scheme, for now
(load-theme 'zenburn)

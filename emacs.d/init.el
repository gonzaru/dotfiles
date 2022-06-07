;; reload configuration
;; M-x: load-file ~/.emacs.d/init.el
;; M-x: eval-buffer (with init.el opened)

;; disable welcome message
(setq inhibit-startup-screen t)

;; disable scratch message
(setq initial-scratch-message nil)

;; gui
(if (display-graphic-p)
    (progn
      ;; enable menu bar
      (menu-bar-mode t)
      ;; disable tool bar
      (tool-bar-mode -1) 
      ;; disable sroll bar
      ;;(scroll-bar-mode -1) 
      ;; M-x: describe-font
      ;; size value is 1/10pt, so 100 = 10pt
      (set-face-attribute 'default nil :height 140))
  ;; non gui
  ;; disable menu bar
  (menu-bar-mode -1))

;; don't create backup files file~
(setq make-backup-files nil)

;; autosave #file#
(setq auto-save-default nil)

;; autosave files in a backup directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; show column number
(column-number-mode t)

;; matching parentheses, braces, etc.
(show-paren-mode t)

;; highlighting the current line
;; (global-hl-line-mode t)

;; wrap properly at word boundaries
;; (global-visual-line-mode t)

;; show numbers
(global-display-line-numbers-mode t)

;; relative numbers
(setq display-line-numbers-type 'relative)

;; auto update the current file when is changed externally 
(global-auto-revert-mode t)

;; delete using C-h (conflicts with help)
;;(normal-erase-is-backspace-mode t)
(global-set-key (kbd "C-h") 'delete-backward-char)

;; alternative C-h map
;;(global-set-key (kbd "C-?") 'help-command)

;; prevent native compiling (gcc emacs)
(setq native-comp-deferred-compilation nil)

;; wombat theme
(load-theme 'wombat t)

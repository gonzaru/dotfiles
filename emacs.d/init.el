;; reload configuration
;; M-x: load-file ~/.emacs.d/init.el
;; open ~/.emacs.d/init.d & M-x: eval-buffer

;; disable welcome message
(setq inhibit-startup-screen t)

;; disable scratch message
(setq initial-scratch-message nil)

;; gui
(if (display-graphic-p)
    (progn
      ;; disable menu bar
      (menu-bar-mode 1)
      ;; disable tool bar
      (tool-bar-mode -1) 
      ;; disable sroll bar
      ;;(scroll-bar-mode -1) 
      ;; M-x: describe-font
      ;; size value is 1/10pt, so 100 = 10pt
      (set-face-attribute 'default nil :height 140))
  ;; non gui
  (menu-bar-mode -1))

;; don't create backup files file~
(setq make-backup-files nil)

;; autosave #file#
(setq auto-save-default nil)

;; autosave files in a backup directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; show column number
(column-number-mode 1)

;; matching parentheses, braces, etc.
(show-paren-mode 1)

;; highlighting the current line
;; (global-hl-line-mode 1)

;; wrap properly at word boundaries
;; (global-visual-line-mode 1)

;; show numbers
(global-display-line-numbers-mode 1)

;; relative numbers
(setq display-line-numbers-type 'relative)

;; auto update the current file when is changed externally 
(global-auto-revert-mode 1)

;; delete using C-h (conflicts with help)
;; normal-erase-is-backspace-mode 1)
(global-set-key (kbd "C-h") 'delete-backward-char)

;; alternative C-h map
;;(global-set-key (kbd "C-?") 'help-command)

;; prevent native compiling (gcc emacs)
(setq native-comp-deferred-compilation nil)

;; wombat theme
(load-theme 'wombat t)

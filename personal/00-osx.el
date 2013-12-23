;;; OSX only fixes
;; TODO: don't load when linux
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)
(set-default-font "Monaco 12")
;; this hack for magit, assumes that emacs has been installed with homebrew
;; TODO: check that this executable exists
(set-variable 'magit-emacsclient-executable "/usr/local/Cellar/emacs/HEAD/bin/emacsclient")

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq system-uses-terminfo nil)

(dolist (map (append (list minibuffer-local-completion-map
			   minibuffer-local-must-match-map)
                     (when (boundp 'minibuffer-local-filename-completion-map)
                       (list minibuffer-local-filename-completion-map))))
  (define-key map [?\C-w] 'sp-backward-kill-word)
  (icicle-remap 'previous-line 'icicle-previous-prefix-candidate map)
  (icicle-remap 'next-line 'icicle-next-prefix-candidate map))


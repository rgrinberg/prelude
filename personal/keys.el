(global-set-key (kbd "C-x C-w") 'helm-prelude)

;; TODO put chords and misc bindings into own file
(key-chord-define-global "wf" 'ido-find-file)

;; XXX do these works for other major modes?
(key-chord-define-global "vg"     'eval-region)
(key-chord-define-global "vb"     'eval-buffer)
(key-chord-define-global "cg"     "\C-c\C-c")

(key-chord-define-global "zx" 'other-window)
(key-chord-define-global "x1"     'delete-other-windows)
(key-chord-define-global "x0"     'delete-window)
(key-chord-define-global "vc"     'vc-next-action)
(key-chord-define-global "xk"     'kill-this-buffer-if-not-modified)
(key-chord-define-global "\\]" 'ido-switch-buffer)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)

(ac-set-trigger-key "TAB")

(require 'highlight-symbol)
(global-set-key (kbd "C-'") 'highlight-symbol-at-point)
(global-set-key (kbd "C-M-'") 'highlight-symbol-query-replace)
(global-set-key (kbd "C-c C-'") 'highlight-symbol-remove-all)
(add-hook 'prog-mode-hook #'highlight-symbol-nav-mode)

(defun window-half-height ()
  (max 1 (/ (1- (window-height (selected-window))) 2)))

(defun scroll-up-half ()
  (interactive)
  (scroll-up (window-half-height)))

(defun scroll-down-half ()         
  (interactive)                    
  (scroll-down (window-half-height)))

;; vim refugee
(global-set-key (kbd "C-v") 'scroll-up-half)
(global-set-key (kbd "M-v") 'scroll-down-half)


(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))
(global-set-key (kbd "C-`") 'push-mark-no-activate)

(defun exchange-point-and-mark-no-activate ()
  "Identical to \\[exchange-point-and-mark] but will not activate the region."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark nil))
(define-key global-map [remap exchange-point-and-mark] 'exchange-point-and-mark-no-activate)

(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))
(global-set-key (kbd "M-`") 'jump-to-mark)

(global-set-key (kbd "M-i") 'prelude-ido-goto-symbol)
(global-unset-key (kbd "C-\\"))
(global-set-key (kbd "C-\\ C-\\") 'helm-git-grep)
(global-set-key (kbd "C-\\ M-\\") 'helm-git-grep-at-point)
(global-set-key (kbd "C-\\ SPC") 'delete-horizontal-space)
(global-set-key (kbd "C-\\ C-o") 'helm-multi-occur)

(global-set-key (kbd "C-<f12>") 'menu-bar-mode)
(global-set-key (kbd "<f12>")
                (lambda ()
                  (interactive)
                  (message "this should screw with ecb")
                  (if (boundp 'ecb-minor-mode)
                      (ecb-toggle-ecb-windows)
                    (ecb-activate))))
(global-set-key (kbd "C-x C-r") 'sudo-edit)
(global-set-key (kbd "C-\\ M-x") 'lacarte-execute-command)


(push "/usr/share/emacs/site-lisp" load-path)
(setq merlin-use-auto-complete-mode t)

(autoload 'merlin-mode "merlin" "Merlin mode" t)
(add-hook 'tuareg-mode-hook 'merlin-mode)
(add-hook 'caml-mode-hook 'merlin-mode)

(defun test-loaded ()
  (interactive)
  (message "testing"))

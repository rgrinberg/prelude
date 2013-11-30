(push "/usr/share/emacs/site-lisp" load-path)

(setq merlin-use-auto-complete-mode t)

(autoload 'merlin-mode "merlin" "Merlin mode" t)
(add-hook 'tuareg-mode-hook 'merlin-mode)
(add-hook 'caml-mode-hook 'merlin-mode)

;; Setup environment variables using opam
(dolist (var (car (read-from-string (shell-command-to-string "opam config env --sexp"))))
  (setenv (car var) (cadr var)))

;; Update the emacs path
;; TODO unfuck this way of handling paths
(setq exec-path (split-string (getenv "PATH") path-separator))
(add-to-list 'exec-path "~/.cabal/bin")

;; Update the emacs load path
(push (concat (getenv "OCAML_TOPLEVEL_PATH") "/../../share/emacs/site-lisp") load-path)

(defun my-merlin-hook ()
  "merlin overwrites C-c C-r, we set it back"
  (define-key merlin-mode-map (kbd "C-c C-r") 'tuareg-eval-region))

(add-hook 'merlin-mode-hook 'my-merlin-hook)

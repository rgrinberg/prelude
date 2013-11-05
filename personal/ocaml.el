(push "/usr/share/emacs/site-lisp" load-path)

(setq merlin-use-auto-complete-mode t)

(autoload 'merlin-mode "merlin" "Merlin mode" t)
(add-hook 'tuareg-mode-hook 'merlin-mode)
(add-hook 'caml-mode-hook 'merlin-mode)

;; Setup environment variables using opam
(dolist (var (car (read-from-string (shell-command-to-string "opam config env --sexp"))))
  (setenv (car var) (cadr var)))

;; Update the emacs path
(setq exec-path (split-string (getenv "PATH") path-separator))

;; Update the emacs load path
(push (concat (getenv "OCAML_TOPLEVEL_PATH") "/../../share/emacs/site-lisp") load-path)

;; Automatically load utop.el
(autoload 'utop "utop" "Toplevel for OCaml" t)

(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
(add-hook 'typerex-mode-hook 'utop-setup-ocaml-buffer)

(defun my-merlin-hook ()
  "merlin overwrites C-c C-r, we set it back"
  (define-key merlin-mode-map (kbd "C-c C-r") 'tuareg-eval-region))

(add-hook 'merlin-mode-hook 'my-merlin-hook)

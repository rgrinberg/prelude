
;; (require 'elixir-mode)
(defun elixir-mode-compile-on-save ()
  "Elixir mode compile files on save."
  (and (file-exists (buffer-file-name))
       (file-exists (elixir-mode-compiled-file-name))
       (elixir-cos-mode t)))
(add-hook 'elixir-mode-hook 'elixir-mode-compile-on-save)

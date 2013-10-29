(require 'package)
;; don't need this for now
;; (add-to-list 'package-archives
;;              '("marmalade" .
;;                "http://marmalade-repo.org/packages/"))
(package-initialize)

;; My packages
(setq prelude-packages (append '(
                                 auto-complete
                                 popup
                                 solarized-theme
                                 elixir-mode
                                 ) prelude-packages))

;; Install my packages
(prelude-install-packages)

(scroll-bar-mode -1)
(load-theme 'manoj-dark t)

(require 'auto-complete-config)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-auto-complete-mode t)
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)

(ac-set-trigger-key "TAB")

;; not sure why the local lambda def isn't working
(defun swap (l)
  (if (cdr l)
      (cons (cadr l) (cons (car l) (cddr l)))))

(defun ido-jump-to-window ()
  (interactive)
  (let* ((swap (lambda (l)
                 (if (cdr l)
                     (cons (cadr l) (cons (car l) (cddr l)))
                   l)))
         ;; Swaps the current buffer name with the next one along.
         (visible-buffers (swap (mapcar '(lambda (window) (buffer-name (window-buffer window))) (window-list))))
         (buffer-name (ido-completing-read "Window: " visible-buffers))
         window-of-buffer)
    (if (not (member buffer-name visible-buffers))
        (error "'%s' does not have a visible window" buffer-name)
      (setq window-of-buffer
            (delq nil (mapcar '(lambda (window)
                                 (if (equal buffer-name (buffer-name (window-buffer window)))
                                     window
                                   nil))
                              (window-list))))
      (select-window (car window-of-buffer)))))

(global-set-key (kbd "C-x w") 'ido-jump-to-window)

(key-chord-define-global "we" 'ido-jump-to-window)
(key-chord-define-global "wf" 'ido-find-file)
(key-chord-define-global "op" 'ido-switch-buffer)

(key-chord-define-global "vg"     'eval-region)
(key-chord-define-global "vb"     'eval-buffer)
(key-chord-define-global "cy"     'yank-pop)
(key-chord-define-global "cg"     "\C-c\C-c")
                                        ; frame actions

(key-chord-define-global "zx" 'other-window)
(key-chord-define-global "x1"     'delete-other-windows)
(key-chord-define-global "x0"     'delete-window)

(defun kill-this-buffer-if-not-modified ()
  (interactive)
                                        ; taken from menu-bar.el
  (if (menu-bar-non-minibuffer-window-p)
      (kill-buffer-if-not-modified (current-buffer))
    (abort-recursive-edit)))
(key-chord-define-global "xk"     'kill-this-buffer-if-not-modified)
                                        ; file actions
(key-chord-define-global "vc"     'vc-next-action)

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
                                 ag
                                 helm-ag
                                 pabbrev
                                 highlight-symbol
                                 ) prelude-packages))

;; Install my packages
(prelude-install-packages)

(scroll-bar-mode -1)
(load-theme 'deeper-blue t)

(require 'auto-complete-config)
(global-auto-complete-mode t)

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

(defun kill-this-buffer-if-not-modified ()
  (interactive)
                                        ; taken from menu-bar.el
  (if (menu-bar-non-minibuffer-window-p)
      (kill-buffer-if-not-modified (current-buffer))
    (abort-recursive-edit)))

(setq helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
(setq helm-ag-command-option "--all-text")
(setq helm-ag-thing-at-point 'symbol)

;; prelude modules we require

(require 'prelude-python)
(require 'prelude-erlang)
(require 'prelude-haskell)
(require 'pabbrev) ;; fix before enabling
(require 'highlight-symbol)

(setq prelude-whitespace nil)

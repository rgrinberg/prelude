;;; TODO
(require 'package)
(require 'cl) ;; javadoc-lookup warns if cl isn't required
;; don't need this for now
;; (add-to-list 'package-archives
;;              '("marmalade" .
;;                "http://marmalade-repo.org/packages/"))
(package-initialize)

;; My packages
(setq prelude-packages (append '(
                                 ac-etags
                                 yasnippet
                                 auto-complete
                                 popup
                                 flymake-easy
                                 elixir-mode
                                 elixir-mix
                                 elixir-yasnippets
                                 flymake-elixir
                                 dash
                                 caml
                                 ag
                                 tuareg
                                 key-chord
                                 bitlbee
                                 helm-ag
                                 highlight-symbol
                                 enh-ruby-mode
                                 jtags
                                 groovy-mode ;; for gradle only
                                 javadoc-lookup
                                 javap-mode
                                 ecb
                                 android-mode
                                 indent-guide
                                 ghc
                                 window-number
                                 helm-git-grep
                                 helm-themes
                                 monokai-theme
                                 bookmark+
                                 dired+
                                 async
                                 powerline
                                 strings
                                 scion
                                 ht
                                 jedi
                                 lacarte
                                 icicles
                                 replace+
                                 ghci-completion
                                 helm-ag-r
                                 god-mode
                                 helm-rails
                                 projectile-rails
                                 robe
                                 rinari
                                 rvm
                                 nginx-mode
                                 ac-etags
                                 icomplete+
                                 fuzzy-match
                                 el-swank-fuzzy
                                 isearch+
                                 isearch-prop
                                 popwin
                                 helm-swoop
                                 afternoon-theme
                                 ) prelude-packages))

;; Install my packages
(prelude-install-packages)

(require 'key-chord)

(scroll-bar-mode -1)
(disable-theme 'zenburn)
(load-theme 'monokai)
;; (load-theme 'misterioso)
;; (load-theme 'deeper-blue t)
;; (load-theme 'tsdh-light t)
;; (load-theme 'adwaita t)

;; not sure why the local lambda def isn't working
(defun swap (l)
  (if (cdr l)
      (cons (cadr l) (cons (car l) (cddr l)))))

;; this isn't used anymore, can deleted
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
  (if (menu-bar-non-minibuffer-window-p)
      (kill-buffer-if-not-modified (current-buffer))
    (abort-recursive-edit)))

(setq helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
(setq helm-ag-command-option "--all-text")
(setq helm-ag-thing-at-point 'symbol)

;; prelude modules we require

(require 'prelude-programming)
(require 'prelude-js)
(require 'prelude-emacs-lisp)
(require 'prelude-org)
(require 'prelude-python)
(require 'prelude-erlang)
(require 'prelude-haskell)
(require 'prelude-key-chord)
(require 'prelude-helm)
(require 'prelude-ruby)
(require 'prelude-erc)

(require 'highlight-symbol)

(defalias 'ruby-mode 'enh-ruby-mode)

(add-to-list 'auto-mode-alist '("\\.elm\\'" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.gradle\\'" . groovy-mode))

(add-hook 'enh-ruby-mode-hook
          (lambda ()
            ;; enh-ruby-mode overwrites this mode?
            (define-key enh-ruby-mode-map (kbd "RET") 'newline-and-indent)))

(setq prelude-whitespace nil)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(setq el-get-sources
      '(el-get
        ;; not sure wtf is wrong with this dependency but i must include it manually
        (:name ocp-indent
               :type http
               :url "https://raw.github.com/OCamlPro/ocp-indent/master/tools/ocp-indent.el"
               :after (progn
                        (require 'ocp-indent)))

        (:name utop
               :type http
               :url "https://raw.github.com/diml/utop/master/src/top/utop.el"
               :after (progn
                        (autoload 'utop "utop" "Toplevel for OCaml" t)
                        (autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
                        (add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
                        (add-hook 'typerex-mode-hook 'utop-setup-ocaml-buffer)))
        (:name goto-last-change
               :after (progn
                        (global-set-key (kbd "C-x C-/") 'goto-last-change)))))

;; install any packages not installed yet
(mapc (lambda (f)
        (let ((name (plist-get f :name)))
          (when (not (require name nil t)) (el-get-install name))))
      el-get-sources)

(setq my:el-packages
      (append
       '(crontab-mode)
       (mapcar 'el-get-as-symbol (mapcar 'el-get-source-name el-get-sources))))

(el-get 'sync my:el-packages)

;; (add-to-list 'load-path "/home/rudi/reps/jdee-code/jdee/dist/jdee-2.4.2/lisp")
;; (load "jde")

(setq-default cursor-type 'bar)

;; TODO: wrong
;; (setq android-mode-sdk-dir "~/bin/adt-bundle/sdk")
(setq android-mode-sdk-dir "~/android-sdk")

(require 'fuzzy-match)

(require 'window-number)
(window-number-meta-mode)

(require 'indent-guide)
(indent-guide-global-mode)

;; opens ansi-term in bash
;; (eval-after-load 'tramp (setenv "SHELL" "/bin/bash"))
(require 'bookmark+)
(require 'dired+)

(require 'powerline)
(powerline-default-theme)

(require 'lacarte) ;; doesn't work with ido unfortunately
(require 'replace+)
(blink-cursor-mode)

(require 'god-mode)
(add-to-list 'god-exempt-major-modes 'dired-mode)

(require 'icomplete+)
(icomplete-mode 1)

(eval-after-load "isearch" '(require 'isearch+))

(require 'icicles)
(icy-mode 1)


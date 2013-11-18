(require 'package)
(require 'cl) ;; javadoc-lookup warns if cl isn't required
;; don't need this for now
;; (add-to-list 'package-archives
;;              '("marmalade" .
;;                "http://marmalade-repo.org/packages/"))
(package-initialize)

;; My packages
(setq prelude-packages (append '(
                                 auto-complete
                                 popup
                                 elixir-mode
                                 elixir-mix
                                 elixir-yasnippets
                                 dash
                                 caml
                                 ag
                                 tuareg
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
                                 ) prelude-packages))

;; Install my packages
(prelude-install-packages)

(scroll-bar-mode -1)
;; (load-theme 'deeper-blue t)
;; (load-theme 'tsdh-light t)
;; (load-theme 'adwaita t)

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
(require 'prelude-ruby)
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
        (:name pabbrev
               :type http
               :url "https://raw.github.com/phillord/phil-emacs-packages/master/pabbrev.el"
               :after (progn
                        (require 'pabbrev)
                        (global-pabbrev-mode)))
        (:name ocp-indent
               :type http
               :url "https://raw.github.com/OCamlPro/ocp-indent/master/tools/ocp-indent.el"
               :after (progn
                        (require 'ocp-indent)))
        ;; (:name jdee
        ;;        :website "http://jdee.sourceforge.net/"
        ;;        :description "The JDEE is an add-on software package that turns Emacs into a comprehensive system for creating, editing, debugging, and documenting Java applications."
        ;;        :type svn
        ;;        :url "https://jdee.svn.sourceforge.net/svnroot/jdee/trunk/jdee")
               ;; :build ("touch `find . -name Makefile`" "make")
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

(add-to-list 'load-path "/home/rudi/reps/jdee-code/jdee/dist/jdee-2.4.2/lisp")
(load "jde")

(setq android-mode-sdk-dir "~/bin/adt-bundle/sdk")

(require 'window-number)
(window-number-meta-mode)

(require 'indent-guide)
(indent-guide-global-mode)


(defun bitlbee-netrc-identify ()
  "Auto-identify for Bitlbee channels using authinfo or netrc.
    
    The entries that we look for in netrc or authinfo files have
    their 'port' set to 'bitlbee', their 'login' or 'user' set to
    the current nickname and 'server' set to the current IRC
    server's name.  A sample value that works for authenticating
    as user 'keramida' on server 'localhost' is:
    
    machine localhost port bitlbee login keramida password supersecret"
  (interactive)
  (when (string= (buffer-name) "&bitlbee")
    (let* ((secret (plist-get (nth 0 (auth-source-search :max 1
                                                         :host erc-server
                                                         :user "rgrinberg"
                                                         :port "bitlbee"))
                              :secret))
           (password (if (functionp secret)
                         (funcall secret)
                       secret)))
      (erc-message "PRIVMSG" (concat (erc-default-target) " " "identify" " " password) nil))))

;; Enable the netrc authentication function for &biblbee channels.
(add-hook 'erc-join-hook 'bitlbee-netrc-identify)

(defun bitlbee-connect ()
  (interactive)
  (erc :server "localhost" :port 6667 :nick "rgrinberg"))

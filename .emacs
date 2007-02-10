;(load "term/vt100.el" nil t)
;(load "xt-mouse.el" nil t)

(and (equal (getenv "TERM") "xterm")
     (xterm-mouse-mode t))
(defun up-slightly () (interactive) (scroll-up 1))
(defun down-slightly () (interactive) (scroll-down 1))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

;(custom-set-variables
; '(load-home-init-file t t))
;(custom-set-faces)

; Things that come with XEmacs that we don't like and can't easily change with
; advice.

;;; XXX we need a more general patching-function; copy and paste is not
;;; maintainable.

;; Many colors have numbers in their names, so let's not strip them out, OK?
(xemacs-only
 (require 'facemenu)
 (defun list-colors-display (&optional list)
   "Display names of defined colors, and show what they look like.
If the optional argument LIST is non-nil, it should be a list of
colors to display.  Otherwise, this command computes a list
of colors that the current display can handle."
   (interactive)
   (setq list
	 (facemenu-unique
	  (mapcar 'facemenu-canonicalize-color
		  (mapcar 'car (read-color-completion-table)))))
   (with-output-to-temp-buffer "*Colors*"
     (save-excursion
       (set-buffer standard-output)
       (let ((facemenu-unlisted-faces t)
	     s)
	 (while list
	   (if t ;(not (string-match "[0-9]" (car list)))
	       (progn
		 (setq s (point))
		 (insert (car list))
		 (indent-to 20)
		 (put-text-property s (point) 'face
				    (facemenu-get-face
				     (intern (concat "bg:" (car list)))))
		 (setq s (point))
		 (insert "  " (car list) "\n")
		 (put-text-property s (point) 'face
				    (facemenu-get-face
				     (intern (concat "fg:" (car list)))))))
	   (setq list (cdr list))))))))

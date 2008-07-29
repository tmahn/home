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

;;; Attempt to automatically get pretty-printing in lisp-interaction-mode.

;; eval-pretty-print-last-sexp
(xemacs-only
 (require 'cl-extra)
 (defun eval-prettyprint-last-sexp ()
   "Evaluate sexp before point; print value into current buffer."
   (interactive)
   (let ((standard-output (current-buffer)))
     (cl-prettyprint (adn-eval-last-sexp))
     (terpri)))

 ;; XEmacs change, based on Bob Weiner suggestion
 (defun adn-eval-last-sexp ()
   "Evaluate sexp before point."
   (interactive "P")
   (let ((opoint (point))
	 ignore-quotes)
     (eval-interactive
      (letf (((syntax-table) emacs-lisp-mode-syntax-table))
	(save-excursion
	  ;; If this sexp appears to be enclosed in `...' then
	  ;; ignore the surrounding quotes.
	  (setq ignore-quotes (or (eq (char-after) ?\')
				  (eq (char-before) ?\')))
	  (forward-sexp -1)
	  ;; vladimir@cs.ualberta.ca 30-Jul-1997: skip ` in
	  ;; `variable' so that the value is returned, not the
	  ;; name.
	  (if (and ignore-quotes
		   (eq (char-after) ?\`))
	      (forward-char))
	  (save-restriction
	    (narrow-to-region (point-min) opoint)
	    (let ((expr (read (current-buffer))))
	      (if (eq (car-safe expr) 'interactive)
		  ;; If it's an (interactive ...) form, it's
		  ;; more useful to show how an interactive call
		  ;; would use it.
		  `(call-interactively
		    (lambda (&rest args)
		      ,expr args))
		  expr)))))))))

(fsfmacs-only
 ;; This isn’t quite right but accomplishes something similar.
 (defun eval-last-sexp-print-value (value)
   ;; cl-prettyprint throws in an extra newline at the start... It throws one
   ;; at the end too, but let’s not worry about that now.
   (let ((old-point (point)))
     (cl-prettyprint value)
     (save-excursion
       (setf (point) old-point)
       (when (looking-at "\n\n")
	 (delete-char 1))))))


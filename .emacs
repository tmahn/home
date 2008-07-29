(require 'cl)

(setq custom-file (expand-file-name "~/.emacs-custom.el"))
(load custom-file)

;;; Originally I tried XEmacs, but it complained about a missing
;;; win32.el file so I used vim instead for five years. Then I was
;;; going to use emacs, but the version installed on my cygwin machine
;;; hung on startup, so I used XEmacs instead. Now the fact that
;;; XEmacs thinks that certain math symbols like “≠” are from the
;;; chinese-gb2312 character set, and renders them double-width, is
;;; starting to annoy me. So I’m trying to switch to, or at least make
;;; it possible to sometimes use, fsfmacs.
;;;
;;; We’d like all the init files to be as compatible as possible, but
;;; the various emacsen can’t actually share the same init directories
;;; since their byte-compiled files are incompatible. So when fsfmacs
;;; starts up we symlink over all the non-.elc files from ~/.xemacs.
(setq user-init-directory (expand-file-name "~/.emacs.d/"))
(setq real-user-init-directory (expand-file-name "~/.xemacs/"))

(defun adn-call-process-check (command &rest args)
  "Run COMMAND with arguments ARGS, quoting args properly for the
shell, ignoring all output, and raising an error on command failure."
  (flet ((quote-shell-arg (arg)
			  (concat
			   "'" (replace-regexp-in-string "'" "'\\\\''" arg)
			   "'")))
    (let ((ret-value
	   (apply #'call-process-shell-command (quote-shell-arg command)
		  nil nil nil
		  (mapcar #'quote-shell-arg args))))
      (unless (zerop ret-value)
	(error "Shell command %S failed with status %s"
	       (cons command args) ret-value)))))

;; Based on vc-file-tree-walk-internal
(defun adn-walk-tree-removing-elc-links (path)
  "Walk the filesystem below PATH, deleting all broken and .elc symlinks."
  (if (not (file-directory-p path))
      (when (and (file-symlink-p path)
		 (or
		  (string-equal (file-name-extension file) "elc")
		  ;; Clean  up broken symlinks too
		  (not (file-exists-p path))))
	(delete-file path))
    (let ((dir (file-name-as-directory path)))
      (dolist (file (directory-files dir))
	(unless (or
	       (string-equal file ".")
	       (string-equal file ".."))
	  (let ((file (concat dir file)))
	    ;; Skip links to directories to avoid
	    ;; infinite loop
	    (unless
		(and (file-directory-p file)
		     (file-symlink-p file)))
	    (adn-walk-tree-removing-elc-links file)))))))

(defun adn-sync-user-init-directory ()
  "Build a tree of symlinks in user-init-directory pointing to
the files in real-user-init-directory, but omitting all *.elc
files."
  (interactive)
  (unless (file-directory-p user-init-directory)
    (make-directory user-init-directory))
  (adn-call-process-check "lndir" "-silent"
			  real-user-init-directory
			  user-init-directory)
  (adn-walk-tree-removing-elc-links user-init-directory))

(adn-sync-user-init-directory)
(setf user-init-file (concat user-init-directory "init.el"))
(load-file user-init-file)

;; TODO Features from vim that we like
; [ ] Jump list (Tab and Ctrl-O)
; [ ] Spell-check highlighting
;     flyspell-incorrect-face ?
; [ ] Search term highlighting
; [ ] TODO XXX FIXME highlighting
; [ ] Highlight trailing space
; [ ] Automatically trim trailing space on source code (write-contents-hooks?)
; [ ] More right-justification in modeline
;     [ ] Line length
;     [ ] Show region size while marking
; [ ] Wrap output of hyper-apropos
;     We can set truncate-lines to nil, but then the docstrings wrap into the
;     list of symbol names.

(eval-and-compile
  (mapcar (lambda (user-init-subdirectory)
	    (add-to-list 'load-path (concat user-init-directory
					    user-init-subdirectory) t))
	  '("local" "external")))
(load "internal-hacks")

; For calendar
(setq calendar-latitude 40.4)
(setq calendar-longitude -74.0)
(setq calendar-location-name "New York, NY")

(push '("python[0-9.]*" . python-mode) interpreter-mode-alist)

; utf-8; from UTF-8 Setup Mini HOWTO (http://www.maruko.ca/i18n/)
(if (not (emacs-version>= 21 5))
    (require 'un-define))
;      (set-coding-priority-list '(utf-8))
;      (set-coding-category-system 'utf-8 'utf-8)))
(set-default-buffer-file-coding-system 'utf-8)

(defadvice load-terminal-library (after run-terminal-library-hooks activate)
  """We do many custom things with xterm, so we apply this after the default
xterm.el is sourced."""
  (and (equal (device-type) 'tty)
       (equal (getenv "TERM") "xterm")
       (require 'xterm-256-color)

       (list

      ; We want the frame title to be displayed in an xterm, but there's no
      ; way to format the frame-title-format from lisp. So we fake it.
      (require 'xterm-title)
      (defun xterm-title-update ()
	"Update xterm window title with the name of the selected buffer."
	; we don't want to see Minibuffer0 as the title
	(if (eq (minibuffer-depth) 0)
	    (xterm-set-window-title
	     (format "XEmacs: %s%s"
	             ; Some modes (e.g. Hyper Apropos) put a more descriptive
	             ; title in modeline-buffer-identification, but have a
		     ; blah buffer name.
		     (if (not (eq modeline-buffer-identification
				  (default-value
				    'modeline-buffer-identification)))
			 (mapconcat 'cdr modeline-buffer-identification "")
		       (buffer-name))
		     (if (buffer-file-name)
			 (format " (%s)"
				 (abbreviate-file-name
				  (directory-file-name default-directory) 1))
		       "")))))
       (xterm-title-mode t)
      
       (require 'xt-mouse-xmas)
       (xterm-mouse-mode t)

       (set-terminal-coding-system 'utf-8)
       
       (define-key function-key-map "\e[1;5D" [(control left)])
       (define-key function-key-map "\e[1;5C" [(control right)])
       (define-key function-key-map "\e[1;5A" [(control up)])
       (define-key function-key-map "\e[1;5B" [(control down)])
       (define-key function-key-map "\e[1;5H" [(control home)])
       (define-key function-key-map "\e[1;5F" [(control end)])
       (define-key function-key-map "\e[1;3D" [(meta left)])
       (define-key function-key-map "\e[1;3C" [(meta right)])
       (define-key function-key-map "\e[1;3A" [(meta up)])
       (define-key function-key-map "\e[1;3B" [(meta down)])
       (define-key function-key-map "\e[15;5~"  [(control f5)])
       (define-key function-key-map "\e\e[1;3A" [(meta up)])
       (define-key function-key-map "\e\e[1;3B" [(meta down)])
       (define-key function-key-map "\e\e[1;3C" [(meta right)])
       (define-key function-key-map "\e\e[1;3D" [(meta left)])
       (define-key function-key-map [(meta escape) O S] [(meta f4)])
       
       ; We want the key 'Ctrl-+' to be available inside an
       ; xterm. There's not standard character sequence for it, so we
       ; make one up, add it here and in the xterm translations
       ; resource, and hope there are no conflicts.
       ; With help from 
       ; http://lists.gnu.org/archive/html/help-gnu-emacs/2005-03/msg00102.html
       (defvar control-key-map (make-sparse-keymap) "Control keymap.")
       (define-prefix-command 'control-key-map)
       (define-key function-key-map "\e[[" 'control-key-map)
       (define-key control-key-map "C+" [(control +)])
       (define-key control-key-map "c=" [(control =)]))
;       ; Attempts to use Ctrl-[Shift]-Digit are raising the error
;       ; "keysym char must be printable: ?\^G"
;       (let ((n 0))
;	 (while (< n 10)
;	   (define-key control-key-map (format "C%d" n)
;	     (vector (list 'control n)))
;	   (setq n (1+ n))))
       ))

(defun set-frame-background-mode (frame color)
  "Attempt to convey that the FRAME background COLOR is 'light or
'dark. Should only be used on a TTY."
  (setq-default frame-background-mode color)
  (set-frame-property (selected-frame)
		      'background-mode frame-background-mode)
  (let ((frame (selected-frame)))
    (set-frame-property frame 'custom-properties
			(mapcar
			 (lambda (symbol)
			   (if (memq symbol '(light dark))
			       frame-background-mode
			     symbol))
			 (frame-property frame 'custom-properties))))
  (defun get-frame-background-mode (frame)
    frame-background-mode))
(if (eq (device-type) 'tty)
    (set-frame-background-mode (selected-frame) 'light))

; syntax highlighting
(require 'font-lock)

; External packages
(require 'findlib)
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(setq-default session-undo-check -1)


;(require 'ispell)
(setq-default ispell-program-name "aspell")

(require 'rsz-minibuf)
(setq-default resize-minibuffer-mode t)

;; Key bindings and stuff
; C-x C-b should activate the buffer-list
(define-key ctl-x-map [(control b)] 'buffer-menu)
; Use iswitchb-buffer
(require 'iswitchb)
(define-key ctl-x-map [(b)] 'iswitchb-buffer)
; Use redo
(require 'redo)
(define-key global-map [(control +)] 'redo)
(define-key global-map [f3] 'kill-this-buffer)
(global-set-key [(meta f4)] 'kill-this-buffer)
(global-set-key 'home 'beginning-of-line-text)
(define-key help-map [F] 'find-function)
(define-key help-map [V] 'find-variable)

; C-s search for regular expressions
(define-key global-map [(control s)] 'isearch-forward-regexp)
(define-key global-map [(control r)] 'isearch-backward-regexp)
;
(add-hook 'isearch-mode-hook
	  (lambda ()
	    (define-key isearch-mode-map [(up)] 'isearch-ring-advance)
	    (define-key isearch-mode-map [(down)] 'isearch-ring-retreat)))

; Ctrl-F5 reloads
(defun revert-buffer-noconfirm ()
  "Revert the current buffer without confirming the action." (interactive)
  (revert-buffer t t))
(define-key global-map [(control f5)] 'revert-buffer-noconfirm)

; If a make.el file exists, C-c m runs it
(defun make.el ()
  "Load the make.el file" (interactive) (load-file "make.el"))
(define-key global-map [(control c) (m)] 'make.el)
(setq-default compilation-read-command nil)
(define-key global-map [(control c) (M)] 'compile)

; Let tab do lisp-complete in eval-expression (M-:)
(define-key read-expression-map [(tab)] 'lisp-complete-symbol)

; SML-mode
(setq sml-program-name "sml")
(add-hook 'sml-mode-hook
          '(lambda ()
             "Map C-c C-e to run code from the point to the end of the
             buffer."
             (define-key sml-mode-map
	       (kbd "C-c C-e")
	       '(lambda () "" (interactive)
		  (sml-send-region (point) (point-max))))))

(defun insert-shell-command (cmd)
  "Insert the output of the command into the current buffer."
  (interactive "sCommand: ")
  (insert-string (shell-command-to-string cmd)))

; command to insert date
(defun insert-date ()
  "Insert the current date into the buffer."
  (interactive)
  (insert-string (format-time-string "%c")))
   
; Enable scroll wheel
;(defun up-slightly () (interactive) (scroll-up 1))
;(defun down-slightly () (interactive) (scroll-down 1))
;(global-set-key [button-4] 'down-slightly)
;(global-set-key [button-5] 'up-slightly)

; more scrolling
(setq-default scroll-step 1)

; match parens
(paren-set-mode 'paren)

; Allow typing 'y' instead of 'yes' to exit
(fset 'yes-or-no-p 'y-or-n-p)
(setq-default require-final-newline t)

; Set background color
(set-face-background
  'default (make-color-specifier "rgb:DF/DF/DF"))

; Silence warnings about backup-directory-alist when compiling with earlier
; versions
(eval-when-compile (if (not (emacs-version>= 21 5))
      (defvar backup-directory-alist)))
; Don't leave backup files all over
(if (boundp 'backup-directory-alist)
    (push (cons "." (expand-file-name "~/misc/bak")) backup-directory-alist)
    (defun make-backup-file-name (file)
       (expand-file-name
	(concat
	 "~/misc/bak"
	 (char-to-string directory-sep-char)
	 (file-name-nondirectory file)
	 "~"))))

; Stop going into overwrite mode
(overwrite-mode nil)
(defun overwrite-mode (&rest ignored)
  "Disabled due to abuse."
  (interactive)
  (message "Attempt to switch into overwrite-mode ignored."))

(if (not (boundp 'source-directory))
    (setq source-directory 
	  (expand-file-name (concat lisp-directory
				    ".."))))
(defun view-emacs-source-file (file)
  "Open the a file in the emacs source tree.
e.g. (view-emacs-source-file \"simple.el\")"
  (interactive
   (let ((insert-default-directory nil))
     (read-file-name "Source file: " (concat source-directory "/"))))
  (find-file (if (string-match (concat "^" source-directory) file)
		 file
	       (concat source-directory "/" file))))

; Look up keybindings when running apropros
;(setq apropos-do-all t)

(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'emacs-lisp-mode-hook 'auto-fill-mode)
(setq-default default-fill-column 78)
(line-number-mode 1)
(column-number-mode 1)
(setq-default column-number-start-at-one t)

;; Custom modeline
(defvar line-count-string ""
  "Used to show the toal line count in the modeline.")
(make-variable-buffer-local 'line-count-string)
(defun update-line-count-after-change (&optional start end length)
  (let ((old-line-count-string line-count-string))
    (setq line-count-string 
	  (format "/%d" (count-lines (point-min) (point-max))))
    (unless (equal line-count-string old-line-count-string)
      (redraw-modeline)))
  line-count-string)
(add-hook 'find-file-hooks
	  (lambda ()
	    (update-line-count-after-change)
	    (pushnew 'update-line-count-after-change after-change-functions)))

(setq-default modeline-modified '("%1* "))
(setq-default modeline-buffer-identification '("%21b"))
; Don't show always-on modes in the modeline
(defvar minor-mode-alist-ignore
  '(xterm-title-mode font-lock-mode xterm-mouse-mode filladapt-mode))
(setq-default
 modeline-format
 (list
  ; XXX since frame-width is evaluated once at the beginning, right
  ; justification will be lost if the window is resized or a window is
  ; split horizontally
  (list (- (frame-width) 3)
	(cons modeline-modified-extent 'modeline-modified)
	(cons modeline-buffer-id-extent 'modeline-buffer-identification)
	" "
	(let ((mode-string global-mode-string))
	  (if mode-string (list mode-string " ")))
	"%[("
	(cons modeline-minor-mode-extent
	      ; XXX There has to be a better way to strip out elements from
	      ; a list
	      (list "" 'mode-name
		    (progn
		      (mapcar
		       (lambda (mode)
			 (setq minor-mode-alist
			       (remassoc mode minor-mode-alist)))
		       minor-mode-alist-ignore)
		      minor-mode-alist)))
	(cons modeline-narrowed-extent "%n")
	'modeline-process
	")%] %l,%c"
	'line-count-string)
  (list 3 "%p")))

; calendar keybindings
(add-hook 'calendar-load-hook
          '(lambda ()
             (define-key calendar-mode-map ">" 'scroll-calendar-left)
             (define-key calendar-mode-map "<" 'scroll-calendar-right)))

; random stuff
(defun adn-active-key-count ()
  (apply '+ (mapcar 'keymap-fullness (current-keymaps))))

; ===================
; From sample.init.el

;;; ********************
;;; Put all of your autosave files in one place, instead of scattering
;;; them around the file system.  This has many advantages -- e.g. it
;;; will eliminate slowdowns caused by editing files on a slow NFS
;;; server.  (*Provided* that your home directory is local or on a
;;; fast server!  If not, pick a value for `auto-save-directory' that
;;; is fast fast fast!)
;;;
;;; Unfortunately, the code that implements this (auto-save.el) is
;;; broken on Windows prior to 21.4.
(unless (and (eq system-type 'windows-nt)
             (not (emacs-version>= 21 4)))
  (setq auto-save-directory (expand-file-name "~/.autosave/")
        auto-save-directory-fallback auto-save-directory
        auto-save-hash-p nil
        efs-auto-save t
        efs-auto-save-remotely nil
        ;; now that we have auto-save-timeout, let's crank this up
        ;; for better interactive response.
        auto-save-interval 2000
        )
  )
(setq-default auto-save-list-file-prefix "~/.autosave/.saves-")

;;; ********************
;;; Filladapt is an adaptive text-filling package.  When it is enabled it
;;; makes filling (e.g. using M-q) much much smarter about paragraphs
;;; that are indented and/or are set off with semicolons, dashes, etc.

(require 'filladapt)
(setq-default filladapt-mode t)
(when (fboundp 'turn-off-filladapt-mode)
  (add-hook 'c-mode-hook 'turn-off-filladapt-mode)
  (add-hook 'outline-mode-hook 'turn-off-filladapt-mode))


;;; ********************
;;; lazy-lock is a package which speeds up the highlighting of files
;;; by doing it "on-the-fly" -- only the visible portion of the
;;; buffer is fontified.  The results may not always be quite as
;;; accurate as using full font-lock or fast-lock, but it's *much*
;;; faster.  No more annoying pauses when you load files.

(if (fboundp 'turn-on-lazy-lock)
  (add-hook 'font-lock-mode-hook 'turn-on-lazy-lock))

;; I personally don't like "stealth mode" (where lazy-lock starts
;; fontifying in the background if you're idle for 30 seconds)
;; because it takes too long to wake up again.
(setq lazy-lock-stealth-time nil)

; End sample.init.el
; ==================

;(defun autocompile nil
;  "compile self if ~/.xemacs/init.el"
;  (interactive)
;  (require 'bytecomp)
;  (if (equal buffer-file-name user-init-file)
;      (byte-compile-file (buffer-file-name))))

;(add-hook 'after-save-hook 'autocompile)

; Clean up GUI: no menubar, toolbar, scrollbars, or tabs
(customize-set-variable 'toolbar-visible-p nil)
(customize-set-variable 'gutter-buffers-tab-visible-p nil)
(set-specifier vertical-scrollbar-visible-p nil)
(set-specifier horizontal-scrollbar-visible-p nil)
(set-specifier menubar-visible-p nil)

; Handle escapes in shell (currently only works well in GUI)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(setq-default shell-file-name "/bin/bash")
(eval-when-compile (require 'shell))
(add-hook 'shell-mode-hook 
	  (lambda ()
	    (message "shell-mode-hook")
	    (pushnew "--login" explicit-bash-args)))

; Needs rewrite
(defun adn-file-complete ()
  "Perform completion on file name preceding point (stolen from wid-edit.el)"
  (interactive)
  (let* ((end (point))
	 (beg (save-excursion
		; TODO use syntax tables
		(skip-chars-backward "^ \n\"")
		(point)))
	 (pattern (buffer-substring beg end))
;	 (dummy (message (concat "filename is "  pattern)))
	 (name-part (file-name-nondirectory pattern))
	 (directory (file-name-directory pattern))
	 (completion (file-name-completion name-part directory)))
    (cond ((eq completion t))
	  ((null completion)
	   (message "Can't find completion for \"%s\"" pattern)
	   (ding))
	  ((not (string= name-part completion))
	   (delete-region beg end)
	   (insert (expand-file-name completion directory)))
	  (t
	   (message "Making completion list...")
	   (with-output-to-temp-buffer "*Completions*"
	     (display-completion-list
	      (sort (file-name-all-completions name-part directory)
		    'string<)))
	   (message "Making completion list...%s" "done")))))
(global-set-key [(control c) f] 'adn-file-complete)

(setq-default enable-recursive-minibuffers t)

(defun byte-recompile-user-init-directory ()
  "Recompile everything in the user init directory that needs it."
  (interactive)
  (byte-recompile-directory user-init-directory 0))
(add-hook 'kill-emacs-hook 'byte-recompile-user-init-directory)

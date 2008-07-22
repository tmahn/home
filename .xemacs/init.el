;; TODO Features from vim that we like
; [ ] Jump list (Tab and Ctrl-O)
; [ ] Spell-check highlighting
;     flyspell-incorrect-face ?
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
	  '("local" "external" "external/slime" "external/slime/contrib")))
(load "internal-hacks")

(setq-default gc-cons-threshold 10000000)

; For calendar
(setq calendar-latitude 40.4)
(setq calendar-longitude -74.0)
(setq calendar-location-name "New York, NY")

(push '("python[0-9.]*" . python-mode) interpreter-mode-alist)

; utf-8; from UTF-8 Setup Mini HOWTO (http://www.maruko.ca/i18n/)
(if (not (emacs-version>= 21 5))
    (require 'un-define)
      (set-coding-priority-list '(utf-8))
      (set-coding-category-system 'utf-8 'utf-8))
(set-default-buffer-file-coding-system 'utf-8)

(defun define-keys (keymap &rest key-def-plist)
  "Like `define-key', but you can pass in mulitiple pairs of keys and defs."
  (while key-def-plist
    (define-key keymap (pop key-def-plist) (pop key-def-plist)))
  t)

(defadvice load-terminal-library (after run-terminal-library-hooks activate)
  "We do many custom things with xterm, so we apply this after the default
xterm.el is sourced."
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
       (define-key function-key-map "\e[1;2A" [(shift up)])
       (define-key function-key-map "\e[1;2B" [(shift down)])
       (define-key function-key-map "\e[1;2C" [(shift right)])
       (define-key function-key-map "\e[1;2D" [(shift left)])

       (define-keys function-key-map
	 "\e[1;2H" [(shift home)]
	 "\e[1;2F" [(shift end)])

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
       (define-key control-key-map "c=" [(control =)])
       (define-key control-key-map "c/" [(control /)])
       (define-key control-key-map "C/" [(control ?\?)]))
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

(eval-when-compile
  (unless (boundp 'x-color-list-internal-cache))
      (defvar x-color-list-internal-cache))
(defun unfudge-x-colors ()
  "For some reason (color-list) was returning a list of (string) lists instead
of a list of strings. This fixes that."
  (when (and (listp (first (color-list)))
	     (boundp 'x-color-list-internal-cache))
    (setf x-color-list-internal-cache
	  (apply #'append x-color-list-internal-cache))))
(defadvice list-colors-display (before unfudge-x-colors activate)
  (unfudge-x-colors))

(defadvice iconify-frame (before iconify-tty activate)
  "If on a tty, try to iconify with XTerm's iconifiy control sequence."
  (if (eq (device-type) 'tty)
      (send-string-to-terminal "\e[2t")))

; syntax highlighting
(require 'font-lock)
(require 'lazy-lock)

(progn
  "This is to fix font-lock of docstrings with parentheses in the first column
(like so).
Usually this line would not be highlighted."
  ;; When the font-lock module is loaded, it sets the syntax table for lisp.
  ;; The fifth entry (index 4) SYNTAX-BEGIN is set to beginning-of-defun,
  ;; which looks for ‘(’ at the start of the line. Changing the entry to nil
  ;; causes font-lock-mode to parse appropriately instead.
  (setf (nth 4 (get 'lisp-mode 'font-lock-defaults)) nil))

(make-face 'font-lock-trailing-whitespace-face
	   "Used to highlight trailing whitespace.")
(set-face-background 'font-lock-trailing-whitespace-face "red")
(make-face 'font-lock-todo-face)
(set-face-background 'font-lock-todo-face "yellow2")
(set-face-foreground 'font-lock-todo-face "darkblue")
(defun my-font-lock-mode-hook ()
  (font-lock-add-keywords
   nil
   ;; The docstring for font-lock-keywords explains the syntax
   '(("\\<\\(?:FIXME\\|TODO\\|XXX\\):?\\>" 0 font-lock-todo-face t)
     ("\\s-+$" 0 font-lock-trailing-whitespace-face t)))
  (turn-on-lazy-lock))
(add-hook 'font-lock-mode-hook 'my-font-lock-mode-hook)
(setq-default lazy-lock-stealth-time nil)

; External packages
(require 'findlib)
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(setq-default session-undo-check -1)

(require 'rsz-minibuf)
(setq-default resize-minibuffer-mode t)

(require 'slime)
(setq-default inferior-lisp-program "sbcl")
(setq slime-net-coding-system 'utf-8-unix)
(slime-setup)

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
(global-set-key [(meta Z)] 'zap-up-to-char)
(define-key help-map [F] 'find-function)
(define-key help-map [V] 'find-variable)

; From eclipse key bindings: Ctrl-/ and Ctrl-Shift-/ to comment and uncomment
(global-set-key [(control /)] 'comment-region)
(defun-when-void uncomment-region (start end)
  "Uncomment region. See `comment-region'."
  (interactive "r")
  (comment-region start end (cons nil nil)))
(global-set-key [(control ?\?)] 'uncomment-region)

; C-s search for regular expressions
(define-key global-map [(control s)] 'isearch-forward-regexp)
(define-key global-map [(control r)] 'isearch-backward-regexp)
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
(define-key global-map [(meta escape) tab] 'lisp-complete-symbol)

; Let TAB = Ctrl-I in help-map
(define-key help-map [tab]
  (lookup-key help-map [(control i)]))

(defun mark-beginning-of-line (arg)
  "Put mark at beginning of line. Arg works as in `beginning-of-line'."
  (interactive "p")
  (mark-something 'mark-beginning-of-line 'beginning-of-line arg))

(define-keys global-map
  [(shift end)] 'mark-end-of-line
  [(shift home)] 'mark-beginning-of-line
  [iso-left-tab] [backtab])

; SML-mode
(setq sml-program-name "sml")
(eval-when-compile
  (require 'sml-mode))
(defun my-sml-mode-hook ()
  "Local customizations for SML mode"
  (setq indent-tabs-mode nil)

  ;; shift-tab should decrease indent
  (define-key sml-mode-map [backtab] 'sml-back-to-outer-indent)

  ;; Map C-c C-e to run code from the point to the end of the buffer
  (define-key sml-mode-map
    (kbd "C-c C-e")
    '(lambda () "" (interactive)
       (sml-send-region (point) (point-max)))))
(add-hook 'sml-mode-hook 'my-sml-mode-hook)

(defun decrease-line-left-margin ()
  "Run `decrease-left-margin' on the current line."
  (interactive)
  (decrease-left-margin (point-at-bol) (point-at-bol 2) nil))
(define-key global-map [backtab] 'decrease-line-left-margin)

; bibtex-mode uses some very questionable keybindings. Let's fix that.
(add-hook 'bibtex-mode-hook
	  '(lambda ()
	     (define-keys bibtex-mode-map
	       [tab] 'indent-for-tab-command
	       [backtab] 'decrease-line-left-margin
               [(meta backspace)] 'backward-kill-word)))

(add-hook 'slime-mode-hook
	  ;; If the current buffer doesn’t specify a package, use :cl-user
	  ;; so that slime-sync-package-and-default-directory won’t error
	  (setq-default slime-find-buffer-package-function
			(lambda ()
			  (or (slime-search-buffer-package) ":cl-user")))
	  '(lambda ()
	     (define-keys slime-mode-map
	       [(control c) (control h)] #'slime-documentation)))
;; Faces

; Cyan is really bright, guys.
(eval-when-compile
  (require 'python-mode))
(add-hook 'python-mode-hook
	  (lambda()
	    (set-face-foreground py-builtins-face "steelblue")
	    (set-face-foreground py-pseudo-keyword-face "mediumpurple")))

; Since we have all the X colors on our tty, let's use them
(set-face-background 'isearch "paleturquoise")
(set-face-foreground 'isearch "black")
(set-face-background 'isearch-secondary "yellow")

(require 'paren)
(set-face-background 'paren-mismatch "DeepPink")
(set-face-background 'paren-match "seagreen3")
(set-face-highlight-p 'paren-match nil)

; We want search highlighting to persist after we're done searching
(defadvice isearch-done (after isearch-highlight-when-done activate)
  (isearch-highlight-all-update))
; but we want to be able to turn it off too
(defun nohls ()
  "Alias for people used to typing :nohls in vim. Calls
`isearch-highlight-all-cleanup'."
  (interactive)
  (isearch-highlight-all-cleanup))

(defun my-flyspell-mode-hook ()
  (loop for face in '(flyspell-incorrect-face
		      flyspell-duplicate-face)
    do
    (remove-face-property face 'foreground)
    (remove-face-property face 'underline)
    (set-face-background face "thistle1")
    (make-face-unbold face)))
(add-hook 'flyspell-mode-hook #'my-flyspell-mode-hook)

;;; Spell-checking.
;;;
;;; Flyspell doesn’t work very well, because it only checks what you type of
;;; move your point over; if you load up a buffer full of misspellings, you’ll
;;; get a screenful of text that looks fine but isn’t.
;;;
;;; TODO:
;;; [ ] keybindings (for now use middle-click)
;;; [ ] Handle real apostrophes (’)
;;; [ ] “i” by itself is a misspelling
;;;
;;; Still, it’s better than nothing at this point.

(require 'flyspell)
(setq-default flyspell-mode-line-string nil)
(setq-default ispell-program-name "aspell")
(defun turn-on-flyspell ()
  "Turn on flyspell mode unconditionally."
  (interactive)
  (flyspell-mode t))
;; `font-lock-mode' seems to take effect everywhere, but for flyspell it seems
;; that you have to add `turn-on-flyspell' to every major-mode-hook. Looking
;; at what `font-lock-mode' does, it adds `font-lock-set-defaults' to
;; `find-file-hooks'. Now this won’t get you spell-checking in the *scratch*
;; buffer; it turns out that font-lock in *scratch* is special-cased in
;; startup.el.
(add-hook 'find-file-hooks #'turn-on-flyspell)

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

; Middle-click should insert at point, not where clicked
(setq-default mouse-yank-at-point t)

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
     (list
      (read-file-name "Source file: " (concat source-directory "/")))))
  (find-file (if (string-match (concat "^" source-directory) file)
		 file
	       (concat source-directory "/" file))))

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
  '(xterm-title-mode font-lock-mode xterm-mouse-mode filladapt-mode
    auto-fill-function))
(setq-default
 modeline-format
 (list
  ; XXX since frame-width is evaluated once at the beginning, right
  ; justification will be lost if the window is resized or a window is
  ; split horizontally
  (list (- (frame-width) 4)
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
  (list 4 "%p")))

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

;;; Mildly disgusting hack to make filladapt not put an indent on subsequent
;;; lines of lisp docstrings. The filladapt algorithm is, roughly
;;;   - Break each line into tokens
;;;   - If the tokens are related in the match-table, and end at the same
;;;     column index, then the lines are in the same paragraph
;;; There is code to handle ‘match-many’ tokens like bullets which cause
;;: subsequent lines to be indented more than the previous ones, but nothing to
;:; handle cases where the first line has a greater indent. So we use advice.
;;;
;;; The `filladapt-debug' function is your friend.
(pushnew '("^  \"" lisp-docstring) filladapt-token-table)
(pushnew '(lisp-docstring beginning-of-line) filladapt-token-match-table)
(pushnew 'lisp-docstring filladapt-token-paragraph-start-table)
(defadvice filladapt-parse-prefixes (around fudge-lisp-docstring activate)
  "Return 0 for the column offset of any lisp-docstring."
  (setf ad-return-value
	(mapcar #'(lambda (x) (if (eq (first x) 'lisp-docstring)
				  `(lisp-docstring 0 ,@(cddr x))
				x))
		ad-do-it)))

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
;; shift-f12 in terminal is f24
(global-set-key [f24] 'byte-recompile-user-init-directory)
(global-set-key [(shift f12)] 'byte-recompile-user-init-directory)

; We have this earlier too, but it gets overridden...
(set-coding-priority-list '(utf-8))

;    (global-set-key "%" 'match-paren)
;      (defun match-paren (arg)
;        "Go to the matching paren if on a paren; otherwise insert %."
;        (interactive "p")
;        (cond ((string-match "[[{(<]"  next-char) (forward-sexp 1))
;              ((string-match "[\]})>]" prev-char) (backward-sexp 1))
;              (t (self-insert-command (or arg 1)))))

(defun getclip ()
  "Retrieve clipboard contents."
  (interactive)
  (insert-shell-command "getclip"))

(defun dos2unix ()
  "Remove all linefeeds from buffer."
  (interactive)
  ; Following the advice of the `perform-replace' docstring
  (save-excursion
    (setf (point) (point-min))
    (while (re-search-forward "" nil t)
      (replace-match "" nil nil))))

(defun revisit-file-in-dos-mode ()
  "Reopen the current file in dos mode. This is almost certainly not the
right way to hide those ^M's, but it seems to work."
  (interactive)
  (let ((this-buffer-file-name (buffer-file-name)))
    (kill-buffer (current-buffer))
    (find-file this-buffer-file-name (get-coding-system 'iso-8859-1-dos))))

;;; Thanks http://justinsboringpage.blogspot.com!
(defun insert-char-above (&optional lines)
 "Insert the character above point into the buffer. LINES (default 1) is the
index of the line to copy from."
 (interactive)
 (let ((c (save-excursion
	    (let ((column (current-column)))
	      (previous-line (or lines 1))
	      (if (eq column (current-column))
		  (char-after))))))
   (when (and c (/= c ?\n))
     (insert (char-to-string c)))))

(defun insert-char-below ()
 "Insert the character below point into the buffer."
 (interactive)
 (insert-char-above -1))

;; bindings from vi
(global-set-key [(control Y)] 'insert-char-above)
(global-set-key [(control E)] 'insert-char-below)

(defun active-modes ()
  (mapcan #'(lambda (x) (let ((sym (first x)))
			  (when (and (boundp sym) (symbol-value sym))
			    (list sym))))
	  minor-mode-alist))

(defun delete-trailing-whitespace ()
  "Remove all trailing whitespace (spaces and tabs) from the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    ;; We don’t use the syntax table because it might have significant
    ;; characters, e.g. ‘~’ in τεχ mode.
    (while (re-search-forward "[ \t]+$" nil t)
      (replace-match ""))))

;;; I don’t double-space after a period.
(setq-default sentence-end-double-space nil)

;; But now `fill-region-as-paragraph' adds a space to lines that end with ‘.’.
;; That function is very crufty, 328 lines, and hasn’t been touched in three
;; years. So we wrap it with cleanup advice.
(defadvice fill-region-as-paragraph
  (around cleanup-after-fill-region-as-paragraph (from &rest extra) activate)
  ad-do-it
  (save-excursion
    (narrow-to-region from (point))
    (delete-trailing-whitespace)))

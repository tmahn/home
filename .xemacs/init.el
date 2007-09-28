;(load "term/vt100.el" nil t)
;(load "xt-mouse-xmas.el" nil t)

;; TODO Features from vim that we like
; [ ] Jump list (Tab and Ctrl-O)
; [ ] Spell-check highlighting
;     flyspell-incorrect-face ?
; [ ] Search term highlighting
; [ ] TODO XXX FIXME highlighting

; For calendar
(setq calendar-latitude 40.4)
(setq calendar-longitude -74.0)
(setq calendar-location-name "New York, NY")

(push '("python2.4" . python-mode) interpreter-mode-alist)

; utf-8; from UTF-8 Setup Mini HOWTO (http://www.maruko.ca/i18n/)
(if (not (emacs-version>= 21 5))
    (require 'un-define))
;      (set-coding-priority-list '(utf-8))
;      (set-coding-category-system 'utf-8 'utf-8)))
(set-default-buffer-file-coding-system 'utf-8)

(and (equal (format "%s" (console-type)) "tty")
     (equal (getenv "TERM") "xterm")

     (list
       (load-file "~/.xemacs/xt-mouse-xmas.el")
       ; This loads all the colours that xterm, supports, but for
       ; as-yet-unknown reasons, they don't get picked up properly.
       ;(load-file "~/.xemacs/xmas-tty-faces256.el")
       (set-terminal-coding-system 'utf-8)
       (xterm-mouse-mode t)
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
;       ; Attempts to use Ctrl-[Shift]-Digit ar raising the error
;       ; "keysym char must be printable: ?\^G"
;       (let ((n 0))
;	 (while (< n 10)
;	   (define-key control-key-map (format "C%d" n)
;	     (vector (list 'control n)))
;	   (setq n (1+ n))))


     (custom-set-faces
       '(font-lock-builtin-face ((((type x mswindows)(class color)(background light))(:foreground "Purple"))(((type tty)(class color))(:foreground "magenta"))))
       '(font-lock-comment-face ((((type x mswindows)(class color)(background light))(:foreground "blue4"))(((type tty)(class color))(:foreground "blue"))))
       '(font-lock-constant-face ((((type x mswindows)(class color)(background light))(:foreground "CadetBlue"))(((type tty)(class color))(:foreground "cyan"))))
       '(font-lock-doc-string-face ((((type x mswindows)(class color)(background light))(:foreground "green4"))(((type tty)(class color))(:foreground "green"))))
       '(font-lock-function-name-face ((((type x mswindows)(class color)(background light))(:foreground "brown4"))(((type tty)(class color))(:foreground "cyan" :bold))))
       '(font-lock-keyword-face ((((type x mswindows)(class color)(background light))(:foreground "red4"))(((type tty)(class color))(:foreground "red" :bold))))
       '(font-lock-preprocessor-face ((((type x mswindows)(class color)(background light))(:foreground "blue3"))(((type tty)(class color))(:foreground "cyan" :bold))))
       '(font-lock-reference-face ((((type x mswindows)(class color)(background light))(:foreground "red3"))(((type tty)(class color))(:foreground "red"))))
       '(font-lock-string-face ((((type x mswindows)(class color)(background light))(:foreground "green4"))(((type tty)(class color))(:foreground "green" :bold))))
       '(font-lock-type-face ((((type x mswindows)(class color)(background light))(:foreground "steelblue"))(((type tty)(class color))(:foreground "cyan" :bold))))
       '(font-lock-variable-name-face ((((type x mswindows)(class color)(background light))(:foreground "magenta4"))(((type tty)(class color))(:foreground "magenta" :bold))))
       '(font-lock-warning-face ((((type x mswindows)(class color)(background light))(:foreground "Red" :bold))(((type tty)(class color))(:foreground "red" :bold))))))

; syntax highlighting
(require 'font-lock)

; External packages
(add-to-list 'load-path (concat user-init-directory "/external") t)
(require 'findlib)
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(setq-default session-undo-check -1)


;(require 'ispell)
(setq-default ispell-program-name "aspell")
;(require 'saveplace)
;(setq-default save-place t)

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
(defun make-dash-k ()
  "(compile \"make -k\""
  (interactive)
  (compile "make -k"))
(define-key global-map [(control c) (M)] 'make-dash-k)

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
(put 'overwrite-mode 'disabled t)

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

(line-number-mode 1)
(column-number-mode 1)
(add-hook 'text-mode-hook
	  (lambda ()
	    (auto-fill-mode)))
(setq-default default-fill-column 78)

; calendar keybindings
(add-hook 'calendar-load-hook
          '(lambda ()
             (define-key calendar-mode-map ">" 'scroll-calendar-left)
             (define-key calendar-mode-map "<" 'scroll-calendar-right)))

; random stuff
(defun adn-active-key-count
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

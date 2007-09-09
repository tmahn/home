;(load "term/vt100.el" nil t)
;(load "xt-mouse-xmas.el" nil t)

; For calendar
(setq calendar-latitude 40.4)
(setq calendar-longitude -74.0)
(setq calendar-location-name "New York, NY")

; utf-8; from UTF-8 Setup Mini HOWTO (http://www.maruko.ca/i18n/)
(require 'un-define)
(set-coding-priority-list '(utf-8))
(set-coding-category-system 'utf-8 'utf-8)

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
       (define-key function-key-map "\e[1;3B" [(meta down)]))

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

;; Key bindings and stuff
; C-x C-b should active the buffer-list
(define-key ctl-x-map "\C-b" 'buffer-menu)

; SML-mode
(setq sml-program-name "sml")
(add-hook 'sml-mode-hook
          '(lambda ()
             "Map C-c C-e to run code from the point to the end of the
             buffer."
             (define-key sml-mode-map
                         (kbd "C-c C-e")
                         '(lambda ()
                            ""
                            (interactive)
                           (sml-send-region (point) (point-max))))))
; command to insert date
(defun insert-date ()
  "Insert the date into the current buffer."
  (interactive)
  (insert-string (shell-command-to-string "date")))
   
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

; Set background color
(set-face-background
  'default (make-color-specifier "rgb:DF/DF/DF"))

; Don't leave backup files all over
(setq make-backup-files nil)

; Look up keybindings when running apropros
;(setq apropos-do-all t)

(line-number-mode 1)
(column-number-mode 1)
(auto-fill-mode)

; calendar keybindings
(add-hook 'calendar-load-hook
          '(lambda ()
             (define-key calendar-mode-map ">" 'scroll-calendar-left)
             (define-key calendar-mode-map "<" 'scroll-calendar-right)))

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

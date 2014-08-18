;; Granville Barnett's Emacs Config
;; granvillebarnett@gmail.com

;; -----------------------------------------------------------------------------
;; Emacs generated
;; -----------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-start 1)
 '(ac-modes (quote (emacs-lisp-mode sml-mode graphviz-dot-mode erlang-shell-mode lisp-mode lisp-interaction-mode slime-repl-mode c-mode cc-mode c++-mode go-mode java-mode malabar-mode clojure-mode clojurescript-mode scala-mode scheme-mode ocaml-mode tuareg-mode coq-mode haskell-mode agda-mode agda2-mode perl-mode cperl-mode python-mode ruby-mode lua-mode tcl-mode ecmascript-mode javascript-mode js-mode js2-mode php-mode css-mode makefile-mode sh-mode fortran-mode f90-mode ada-mode xml-mode sgml-mode ts-mode sclang-mode verilog-mode qml-mode erlang-mode)))
 '(custom-safe-themes (quote ("6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "9eb5269753c507a2b48d74228b32dcfbb3d1dbfd30c66c0efed8218d28b8f0dc" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" default))))
;; -----------------------------------------------------------------------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; *****************************************************************************
;; Basics
;; *****************************************************************************
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)            
(setq inhibit-startup-message t inhibit-startup-echo-area-message t)
(setq ring-bell-function 'ignore)                                   
(line-number-mode t)                     
(column-number-mode t)                   
(size-indication-mode t)                 
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq default-major-mode 'text-mode)
(global-font-lock-mode t)
(ido-mode t)
(setq ido-enable-flex-matching t) ; fuzzy matching is a must have
(setq ido-enable-last-directory-history nil) ; forget latest selected directory

;; dump all backup files in specific location
(defun my-backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let (backup-root bpath)
    (setq backup-root "~/.emacs.d/emacs-backup")
    (setq bpath (concat backup-root fpath "~"))
    (make-directory (file-name-directory bpath) bpath)
    bpath
  )
)
(setq make-backup-file-name-function 'my-backup-file-name)

(require 'uniquify)

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;; *****************************************************************************
;; Elpa 
;; *****************************************************************************
(require 'package)

(setq package-archives '(("elpa" . "http://elpa.gnu.org/packages/")
                           ("marmalade" . "http://marmalade-repo.org/packages/")
                           ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(magit autopair 
                      rainbow-delimiters 
		      haskell-mode 
		      pandoc-mode
                      markdown-mode 
		      ghc 
		      flycheck 
		      erlang 
		      go-mode
                      flycheck-hdevtools 
		      soft-charcoal-theme
                      google-this 
		      sml-mode
		      ack-and-a-half 
		      d-mode 
		      rust-mode
                      auto-complete 
		      tuareg 
		      evil 
		      smart-mode-line
		      graphviz-dot-mode
		      elixir-mode 
		      elixir-mix)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; *****************************************************************************
;; Configurations
;; *****************************************************************************
(load-theme 'soft-charcoal t)
(evil-mode)
(sml/setup)
(sml/apply-theme 'dark) 

;; Autocomplete ----------------------------------------------------------------
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(setq ac-auto-show-menu 0.)		; show immediately
;; -----------------------------------------------------------------------------

;; AucTeX ----------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/no-elpa/auctex")
(add-to-list 'load-path "~/.emacs.d/no-elpa/auctex/preview")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)                  
(setq TeX-parse-self t)
(setq-default TeX-master nil)           ;set up AUCTeX to deal with
                                        ;multiple file documents.

(setq reftex-plug-into-AUCTeX t)

(setq reftex-label-alist
   '(("axiom"   ?a "ax:"  "~\\ref{%s}" nil ("axiom"   "ax.") -2)
     ("theorem" ?h "thr:" "~\\ref{%s}" t   ("theorem" "th.") -3)))

(setq reftex-cite-format 'natbib)
(add-hook 'LaTeX-mode-hook 'reftex-mode)
;; -----------------------------------------------------------------------------

(defun common-hooks() 
  (auto-highlight-symbol-mode)
  (autopair-mode)
  (show-paren-mode)
  (rainbow-delimiters-mode))

;; Ocaml -----------------------------------------------------------------------
(defun ocp-indent-buffer ()
 (interactive nil)
 (ocp-indent-region (point-min) (point-max)))

(add-to-list 'load-path "~/.opam/4.01.0/share/emacs/site-lisp/")
;; (autoload 'merlin-mode "merlin" "Merlin mode" t)
;; (add-hook 'tuareg-mode-hook 'merlin-mode)
;; (add-hook 'caml-mode-hook 'merlin-mode)
;;(require 'merlin)
;;(setq -merlin-use-auto-complete-mode t)
(require 'ocp-indent)

(defun ocaml-hooks()
 (local-set-key (kbd "M-e") 'tuareg-eval-buffer)
 (local-set-key (kbd "M-/") 'utop-edit-complete)
 (local-set-key (kbd "M-q") 'ocp-indent-buffer))
 (local-set-key (kbd "M-n") 'merlin-phrase-next)
 (local-set-key (kbd "M-p") 'merlin-phrase-prev)
 (local-set-key (kbd "M-t") 'merlin-type-enclosing)
 (local-set-key (kbd "M-l") 'merlin-locate)

(defun repl-hooks()
 (auto-highlight-symbol-mode)
 (autopair-mode)
 (rainbow-delimiters-mode))

(add-hook 'utop-mode-hook 'repl-hooks)
(add-hook 'tuareg-mode-hook 'common-hooks)
(add-hook 'tuareg-mode-hook 'ocaml-hooks)
;;(add-hook 'tuareg-mode-hook 'merlin-mode)
(add-hook 'tuareg-mode-hook 'common-hooks)

(require 'utop)
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
(add-hook 'typerex-mode-hook 'utop-setup-ocaml-buffer)
;; -----------------------------------------------------------------------------

;; SML
(add-hook 'sml-mode-hook 'common-hooks)

;; Haskell ---------------------------------------------------------------------
(require 'ghc)
(setq haskell-stylish-on-save t)
(define-key haskell-mode-map (kbd "C-x C-s") 'haskell-mode-save-buffer)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'haskell-doc-mode)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-unicode-input-method)
(add-hook 'haskell-mode-hook 'common-hooks)

(defun haskell-hooks()
  (flycheck-mode)
  (local-set-key (kbd "M-e") 'inferior-haskell-load-file))
(add-hook 'haskell-mode-hook 'haskell-hooks)
(add-hook 'inferior-haskell-mode-hook 'repl-hooks)
;; -----------------------------------------------------------------------------

;; C ---------------------------------------------------------------------------
(setq c-default-style "linux" c-basic-offset 4)

(defun c-hooks()
  ;; (local-set-key (kbd "ret") 'newline-and-indent)
  (c-set-offset 'arglist-intro '+)	; aligns args split across lines
)

(add-hook 'c-mode-common-hook 'common-hooks)
(add-hook 'c-mode-common-hook 'c-hooks)

;; Elixir
(require 'elixir-mix)
(global-elixir-mix-mode) ;; enable elixir-mix
(add-hook 'elixir-mode-hook 'common-hooks)
(add-hook 'elixir-mode-hook '(lambda ()
	(local-set-key (kbd "M-m") 'elixir-mix-test)
  (local-set-key (kbd "RET") 'newline-and-indent)))

;; Erlang
;; (add-to-list 'load-path "~/.emacs.d/no-elpa/edts")
;; (require 'edts-start)
;; (add-hook 'after-init-hook 'my-after-init-hook)
;; (defun my-after-init-hook ()
;;   (require 'edts-start))
(add-hook 'erlang-mode-hook 'common-hooks)
;; -----------------------------------------------------------------------------

;; *****************************************************************************
;; Keybindings 
;; *****************************************************************************

;; Buffers, info in general
(global-set-key (kbd "M-f") 'ido-find-file)
(global-set-key (kbd "M-b") 'ido-switch-buffer)
(global-set-key (kbd "M-?") 'google-this)
(global-set-key (kbd "M-9") 'query-replace)
(global-set-key (kbd "M-0") 'ack-and-a-half)

;; Packages...
(global-set-key (kbd "M-4") 'persp-switch)
(global-set-key (kbd "M-7") 'magit-status)
(global-set-key (kbd "M--") 'ac-isearch)

;; window stuff
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-+") 'enlarge-window)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-m") 'compile)

;; Variable 
;; -----------------------------------------------------------------------------
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
;;(set-face-attribute 'default nil :height 180)
(set-face-attribute 'default nil :height 160)
(global-unset-key (kbd "M-3"))
(global-set-key (kbd "M-3") '(lambda() (interactive) (insert-string "#")))
;; -----------------------------------------------------------------------------


;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Rahul Tripathi"
      user-mail-address "rahul.tripathi7293@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 16 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 16))
;; (setq doom-font (font-spec :family "Input Mono Narrow" :size 18 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
;;       doom-unicode-font (font-spec :family "Input Mono Narrow" :size 12)
;;       doom-big-font (font-spec :family "Fira Mono" :size 19))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'spacemacs-light)
;; create frames maximized on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq doom-localleader-key ".")
(setq org-directory "~/org/")

;; (setq localleader "\\")
;; (setq evil-snipe-override-evil-repeat-keys nil)
;; (setq doom-localleader-key "\\")
;; (setq doom-localleader-alt-key "M-,")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq evil-want-fine-undo t)
(use-package! pyvenv
  :diminish pyvenv-mode
  :demand t
  :config
  (setq pyvenv-workon "py38")
  (pyvenv-tracking-mode 1))

(use-package! eterm-256color
  :hook (term-mode . eterm-256color-mode))

(add-hook! 'python-mode '(require 'dap-python))
;; (setq pyvenv-default-virtual-env-name "py38")

;; dap-mode javascript
(use-package! javascript-mode
  :mode "\\.js\\'"
  :hook (javascript-mode . lsp-deferred)
  :config
  (setq javascript-indent-level 2)
  (require 'dap-mode)
  (require 'dap-firefox)
  (dap-node-setup))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(use-package! org-sidebar
	:custom
		(org-sidebar-tree-jump-fn 'org-sidebar-tree-jump-source)
)
;; adding org mode settings
;; (add-hook! 'org-mode (org-bullets-mode t) (display-line-numbers-mode 0))
;; finally this worked, but above did not, figure out why later.
(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)))
;; (global-set-key (kbd "M 1") (+workspaces))

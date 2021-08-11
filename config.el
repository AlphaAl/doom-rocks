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
;; Set default font
;; (set-face-attribute 'default nil
;;                     :family "DroidSansMono Nerd Font"
;;                     :height 148
;;                     :size 14
;;                     :weight 'normal
;;                     :width 'normal)
(setq doom-theme 'doom-spacegrey)
;; fixes wierd chars in iterm eamcs
;; Use Emacs terminfo, not system terminfo
;; (setq system-uses-terminfo nil)
;; create frames maximized on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; ********************************************************************************
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq doom-localleader-key ".")
(setq org-directory "~/org/")
;; load the custom scripts
(load! "custom_func")
(use-package! org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (file-truename "~/org/roam")
                      (org-roam-complete-everywhere t))
      :bind (("C-c n l" . org-roam-buffer-toggle)
             ("C-c n f" . org-roam-node-find)
             ("C-c n g" . org-roam-graph)
             ("C-c n i" . org-roam-node-insert)
             ("C-c n c" . org-roam-capture))
      :config
      (setq org-roam-dailies-directory (expand-file-name "~/org/daily"))
      (org-roam-setup))
;; Agenda should be taken from org-roam dailies folder.
;; pretty important logic for filtering out a specific directory
;; we filter out roam directory inside org folder since it is only a knowledge base.
(setq org-agenda-files
      (seq-filter (lambda(x) (not (string-match "/roam/"(file-name-directory x))))
       (directory-files-recursively "~/org/" "\\.org$")
       ))
;; *********************************************************************************

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq evil-want-fine-undo t)
;; needs to be fixed later on.
(use-package! eterm-256color
  :ensure t
  :hook (term-mode . eterm-256color-mode))

;; decent lsp settings for multiple languages.
(use-package! lsp-mode
  :hook ((c-mode ; clangd
          c-or-c++-mode ; clangd
          java-mode ; eclipse-jdtls
          js-mode ; typescript-language-server
          python-mode ; pyls
          dart-mode
          web-mode) . lsp)
  :commands lsp
  :config
  (setq lsp-prefer-flymake nil)
  (setq lsp-eldoc-hook nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-signature-render-documentation nil)
  (use-package lsp-java :after lsp))

(use-package! company-lsp
  :commands company-lsp
  :config (setq company-lsp-cache-candidates 'auto))
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
  (org-sidebar-tree-jump-fn 'org-sidebar-tree-jump-source))
;; adding org mode settings
;; (add-hook! 'org-mode (org-bullets-mode t) (display-line-numbers-mode 0))
;; finally this worked, but above did not, figure out why later.
(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)))
(evil-terminal-cursor-changer-activate)
;; (global-set-key (kbd "M 1") (+workspaces))
;; below one doesnt work
;; (evil-define-key 'insert 'global "jj" 'evil-normal-state)
(use-package! docker
  :ensure t
  :bind ("C-c d" . docker))
;; to display workspace name in modeline
;; (after! doom-modeline
  ;; (setq doom-modeline-persp-name t))

(setq vterm-shell "/opt/homebrew/bin/fish")
(use-package! highlight-indent-guides
  :init
  (setq highlight-indent-guides-method 'character))
(add-hook! 'prog-mode-hook 'highlight-indent-guides-mode)
;; enable elpy only on demand
;; (use-package! elpy
;;   :ensure t
;;   :init
;;   (elpy-enable))
(use-package! pyvenv
  :diminish pyvenv-mode
  :after (python-mode)
  :config
  (setq pyvenv-workon "py38")
  (pyvenv-tracking-mode 1))

;; setting for running jupyter with org
;; (setq ob-async-no-async-languages-alist
      ;; '("jupyter-python"))
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (julia . t)
   (jupyter . t)))
;; saving buffer using command key should put
;; buffer in normal state.
(map! "s-s"
      (cmd! (save-buffer)
            (evil-normal-state)))

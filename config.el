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
(setq doom-theme 'kaolin-galaxy)
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
;; (use-package! org
;;   :bind
;;   (:map org-mode-map
;;    ("C-C-[" . nil)))

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
;; (after! org
;;   (setq org-agenda-files
;;       (seq-filter (lambda(x) (not (string-match "/roam/"(file-name-directory x))))
;;        (directory-files-recursively "~/org/" "\\.org$")
;;        )))
;; (setq org-agenda-file-regexp "\\`^(?!.*/roam/).*\\.org$'\\")
(setq org-agenda-files (quote ("~/org"
                               "~/org/daily")));; * BIBTEX setup with ORG-REF
;; Spell checking (requires the ispell software)
(add-hook 'bibtex-mode-hook 'flyspell-mode)

;; Change fields and format
(setq bibtex-user-optional-fields '(("keywords" "Keywords to describe the entry" "")
                                ("file" "Link to document file." ":"))
bibtex-include-OPTkey nil
bibtex-align-at-equal-sign t)
(setq-default fill-column 160)


(setq bib-files-directory (directory-files
                             (concat (getenv "HOME") "/Documents/references") t "^[A-Za-z].+.bib$")
        pdf-files-directory (concat (getenv "HOME") "/Documents/pdf")
        bib-notes-directory (concat (getenv "HOME") "/Documents/notes"))

(use-package! helm-bibtex
    :config
    (require 'helm-config)
    (setq bibtex-completion-bibliography bib-files-directory
          bibtex-completion-library-path pdf-files-directory
          bibtex-completion-pdf-field "File"
          bibtex-completion-notes-path bib-notes-directory)
    :bind
    (("<menu>" . helm-command-prefix)
     :map helm-command-map
     ("b" . helm-bibtex)
     ("<menu>" . helm-resume)))

(use-package! org-ref
    :config
    (setq org-ref-completion-library 'org-ref-helm-cite
          org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
          org-ref-default-bibliography bib-files-directory
          org-ref-notes-directory bib-notes-directory))

;; BibLaTeX settings
;; bibtex-mode
(setq bibtex-dialect 'biblatex)
(pdf-loader-install)
;; Uses more memory; see https://github.com/politza/pdf-tools/issues/51

;; (setq pdf-view-use-scaling t
;;       pdf-view-use-imagemagick nil)


;; (defun as/get-daily-agenda (&optional date)
;;   "Return the agenda for the day as a string."
;;   (interactive)
;;   (let ((file (make-temp-file "daily-agenda" nil ".txt")))
;;     (org-agenda nil "d" nil)
;;     (when date (org-agenda-goto-date date))
;;     (org-agenda-write file nil nil "*Org Agenda(d)*")
;;     (kill-buffer)
;;     (with-temp-buffer
;;       (insert-file-contents file)
;;       (goto-char (point-min))
;;       (kill-line 2)
;;       (while (re-search-forward "^  " nil t)
;;         (replace-match "- " nil nil))
;;       (buffer-string))))
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
  ;; (setq lsp-enable-symbol-highlighting nil)
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
(require 'zmq)
(require 'jupyter-channel)
(require 'jupyter)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (julia . t)
   ;;(ipython . t)
   (jupyter . t)))
;; (org-babel-do-load-languages 'org-babel-load-languages
;;                              (append org-babel-load-languages
;;                               '((python     . t)
;;                                 (ruby       . t)))
;; saving buffer using command key should put
;; buffer in normal state.
(map! "s-s"
      (cmd! (save-buffer)
            (evil-normal-state)))
 (add-to-list 'load-path (getenv "MU4EHOME"))
;; (straight-use-package
;;  '(mu4e :files (:defaults "mu4e/*.el")))
;; ;; *****************************************
;; (add-to-list 'load-path "/opt/homebrew/Cellar/mu/1.4.15/share/emacs/site-lisp/mu/mu4e")
;; (require 'mu4e)
;; (require 'smtpmail)
;; (setq mu4e-update-interval (* 10 60))
;; (setq mu4e-get-mail-command "mbsync -a")
;; (setq mu4e-maildir "~/.Mail")

;; (setq mu4e-contexts
;;       (list
;;        ;; work account
;;        (make-mu4e-context
;;         :name "Work"
;;         :match-func
;;         (lambda (msg)
;;           (when msg
;;             (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
;;         :vars '((user-mail-address . "rahultripathi.pillarplus@gmail.com")
;;                 (user-full-name . "Rahul Tripathi")
;;                 (mu4e-drafts-folder . "/rahulpp-gmail/Drafts")
;;                 (mu4e-sent-folder . "/rahulpp-gmail/Sent Mail")
;;                 (mu4e-refile-folder . "/rahulpp-gmail/All Mail")
;;                 (mu4e-trash-folder . "/rahulpp-gmail/Trash")
;;                 (mu4e-maildir-shortcuts . (("/rahulpp-gmail/Inbox" . ?i)
;;                                                    ("/rahulpp-gmail/Sent Items" . ?s)
;;         ("/rahulpp-gmail/Drafts"     . ?d)
;;         ("/rahulpp-gmail/Trash"      . ?t)
;;         ("/rahulpp-gmail/All Mail"      . ?a)))))
;;        (make-mu4e-context
;;         :name "Personal"
;;         :match-func
;;         (lambda (msg)
;;           (when msg
;;             (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
;;         :vars '((user-mail-address . "rahul.tripathi7293@gmail.com")
;;                 (user-full-name . "Rahul Tripathi")
;;                 (mu4e-drafts-folder . "/rahul7293-gmail/Drafts")
;;                 (mu4e-sent-folder . "/rahul7293-gmail/Sent Mail")
;;                 (mu4e-refile-folder . "/rahul7293-gmail/All Mail")
;;                 (mu4e-trash-folder . "/rahul7293-gmail/Trash")
;;                 (mu4e-maildir-shortcuts . (("/rahul7293-gmail/Inbox" . ?i)
;;         ("/rahul7293-gmail/[Gmail].Sent Items" . ?s)
;;         ("/rahul7293-gmail/[Gmail].Drafts"     . ?d)
;;         ("/rahul7293-gmail/[Gmail].Trash"      . ?t)
;;         ("/rahul7293-gmail/[Gmail].All Mail"      . ?a)))))))
;; ;; smtp mail settings
;; (setq message-send-mail-function  'smtpmail-send-it
;;       smtpmail-default-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-server  "smtp.gmail.com"
;;       smtpmail-local-domain "gmail.com"
;;       smtpmail-smtp-service 587
;;       smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil)))

;; ;; (load! "mail_settings.el")

;; ;; need to check this one below
;; ;; supposed to make the inserting password in mbsync easy.
;; (setq mu4e~get-mail-password-regexp "^Enter password for account 'Remote': $")
(defun rahul/workspace:switch-next()
  (interactive)
  ;; TODO (kill-minibuffer)
  (+workspace:switch-next))
(map! "C-M-<up>"
       (cmd! (rahul/workspace:switch-next)))
(map! "C-M-<down>"
       (cmd! (+workspace:switch-previous)))
(map! "C-M-n"
       (cmd! (+workspace/new)))
;; (map! "C-M-<backspace>"
;;        (cmd! (+workspace/clo)))
(map! "C-M-<right>"
      (cmd! (next-buffer)))
(map! "C-M-<left>"
      (cmd! (previous-buffer)))
(map! "C-M-\\"
      (cmd! (ivy-switch-buffer)))
(map! "C-M-'"
      (cmd! (+ivy/switch-workspace-buffer)))
(map! "C-M-<backspace>"
      (cmd! (kill-buffer)))

(xterm-mouse-mode 1)
(map! "<mouse-5>"
      (cmd! (scroll-up-line)))
(map! "<mouse-4>"
      (cmd! (scroll-down-line)))
(setq biblio-download-directory "~/Documents/pdf/")
(setenv "WORKON_HOME" "~/miniforge3/envs/")
(require 'csv-mode)
;; (org-babel-do-load-languages 'org-babel-load-languages '((dot . t))
;; (setq gud-pdb-command-name "python -m pdb")

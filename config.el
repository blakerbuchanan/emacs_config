;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; (setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-tomorrow-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; here is where we want to put all config.el customizations for doom
;; Set the theme
(setq doom-theme 'doom-nord-aurora)

(setq fancy-splash-image "~/.config/doom/black-hole.png")

;; Set the font
;; Really we should verify or check that the font exists before we set it...
(when (doom-font-exists-p "JetBrains Mono")
  (setq doom-font (font-spec :family "JetBrains Mono" :size 14 :weight 'regular)
     doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 12)))

;; display line numbers
(setq display-line-numbers-type t)
(after! projectile
  ;; projectile customizations
  (projectile-mode +1)
  ;; recommended keymap prefix on Windows/Linux
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-project-root-files-bottom-up
      (append '(".projectile") projectile-project-root-files-bottom-up)))

;; maximize upon loading default
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;;(set-frame-parameter nil 'fullscreen 'fullboth)
;;(setq ns-use-native-fullscreen nil)

;; Remove bar at top of screen
(add-to-list 'default-frame-alist '(undecorated . t))

;; chatgpt-shell customizations
(after! chatgpt-shell
  (require 'chatgpt-shell)
  (setq chatgpt-shell-openai-key "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"))

;; ollama customizations
(after! ollama
  (require 'ellama)
  (setopt ellama-language "English")
  (setopt ellama-provider
	  (make-llm-ollama
	   :chat-model "codellama" :embedding-model "codellama")))

(use-package! tree-sitter
   :hook (prog-mode . turn-on-tree-sitter-mode)
   :hook (tree-sitter-after-on . tree-sitter-hl-mode)
   :config
   (require 'tree-sitter-langs)
   ;; This makes every node a link to a section of code
   (setq tree-sitter-debug-jump-buttons t
         ;; and this highlights the entire sub tree in your code
         tree-sitter-debug-highlight-jump-region t))

;; multiple cursors customizations
;; set global key bindings for multiple-cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; save the buffer if focus changes
(add-function :after
after-focus-change-function
        (lambda ()
          (unless (frame-focus-state)
(save-some-buffers t nil))))

;; Use xml-mode for ROS .launch files
(add-to-list 'auto-mode-alist '("\\.launch\\'" . xml-mode))

(after! org
  (setq org-roam-directory "~/org-roam")

  (setq org-todo-keywords
       '((sequence "TODO(t)" "IN-PROGRESS(p!)" "BLOCKED(b@/!)" "|" "DONE(d!)")
        (sequence "READ(r)" "READING(R)" "|" "DONE(d!)")))

 (setq org-todo-keyword-faces
             '(("TODO" . (:foreground "orange" :weight bold))
               ("IN-PROGRESS" . (:foreground "green" :weight bold))
               ("BLOCKED" . (:foreground "red" :weight bold))
               ("DONE" . (:foreground "grey" :weight bold))
               ("READ" . (:foreground "yellow" :weight bold))
               ("READING" . (:foreground "green" :weight bold)))))

(setq-default tab-width 4)  ; Set tab width to 4 spaces

;; Hook to apply custom indentation for all major modes
(defun my-global-indent-settings ()
  (setq tab-width 4))

;; Add the custom hook to all programming modes
(add-hook 'prog-mode-hook 'my-global-indent-settings)

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))


(after! json-mode
  (add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode)))

;; Enable `lsp` for C and C++ modes
(after! lsp-clients
  (set-lsp-priority! 'clangd 1)) ;; give clangd higher priority

(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)

(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

(global-flycheck-mode -1)
(add-hook 'after-init-hook #'global-flycheck-mode -1)

(add-hook 'find-file-hook (lambda () (flycheck-mode -1)))

(defun my-toggle-comment-region-or-line ()
  "Toggle comment on the current line or selected region.
If a region is selected, comment/uncomment the region.
Otherwise, comment/uncomment the current line."
  (interactive)
  (if (use-region-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

(map! :leader "c l" #'my-toggle-comment-region-or-line)  ;; Bind to <leader> c l
(map! :i "M-;" #'my-toggle-comment-region-or-line)  ;; Insert mode
(map! :n "M-;" #'my-toggle-comment-region-or-line)  ;; Normal mode
(map! :v "M-;" #'my-toggle-comment-region-or-line)  ;; Visual mode

(after! dumb-jump
  ;; Set your preferred backend (optional)
  (setq dumb-jump-prefer-searcher 'rg)

  ;; Activate dumb-jump as an xref backend
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate t)

  ;; Bind keys in `global-map` for Emacs-style bindings
  ;; map! sometimes doesn't work, so I just global-set-key after this...
  (map! :leader "M-g o" #'dumb-jump-go
        :leader "M-g b" #'dumb-jump-back
        :leader "M-g q" #'dumb-jump-quick-look
        :leader "M-g w" #'dumb-jump-go-other-window))

(global-set-key (kbd "M-g o") 'dumb-jump-go)
(global-set-key (kbd "M-g b") 'dumb-jump-back)
(global-set-key (kbd "M-g q") 'dumb-jump-quick-look)
(global-set-key (kbd "M-g w") 'dumb-jump-go-other-window)

;; Enable LaTeX preview in Org mode
;;(setq org-startup-with-latex-preview t)

;; Tramp support
;; (after! tramp
;;   (setq tramp-persistency-file-name "~/.config/doom/.cache/tramp")
;;   (defun my/connect-remote-ssh ()
;;     "Prompt for remote host and connect via SSH using Tramp."
;;     (interactive)
;;     (let* ((hosts (or (mapcar #'car tramp-connection-properties)
;;                       '("example.com")))  ; Default if no saved connections
;;            (host (completing-read "Connect to host: " hosts nil nil))
;;            (user (read-string "Username: " (user-login-name)))
;;            (remote-path (format "/ssh:%s@%s:" user host)))
;;       (find-file remote-path)))

;;   (map! :leader
;;          :desc "Connect to remote SSH" "C-c o s" #'my/connect-remote-ssh))

;; (setq tramp-persistency-file-name "~/.config/doom/.cache/tramp")
;; (defun my/connect-remote-ssh ()
;;   "Prompt for remote host and connect via SSH using Tramp."
;;   (interactive)
;;   (let* ((hosts (or (mapcar #'car tramp-connection-properties)
;;                     '("example.com")))  ; Default if no saved connections
;;          (host (completing-read "Connect to host: " hosts nil nil))
;;          (user (read-string "Username: " (user-login-name)))
;;          (remote-path (format "/ssh:%s@%s:" user host)))
;;     (find-file remote-path)))

;; (map! :map global-map
;;       "C-c o s" #'my/connect-remote-ssh)

;; TODO Highlight all

;; TODO Indent highlighted by one tab character

;; TODO Set a key to open a tramp buffer and ssh

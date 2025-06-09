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
  (setq projectile-project-search-path '("~/projects/" "~/Repositories/" "~/workspaces/")))

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
;;(after! ollama
;;(require 'llm-ollama)
;;(require 'ellama)
;;(setopt ellama-language "English")
;;(setopt ellama-provider
;;	(make-llm-ollama
;;	:chat-model "codellama" :embedding-model "codellama")))

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
;; (after! multiple-cursors
;;   (require 'multiple-cursors)
;;   (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;;   (global-set-key (kbd "C->") 'mc/mark-next-like-this)
;;   (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;;   (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

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
       '((sequence "TODO(t)" "IN-PROGRESS(p!)" "BLOCKED(b@/!)" "|"
          "DONE(d!)")))

 (setq org-todo-keyword-faces
             '(("TODO" . (:foreground "orange" :weight bold))
               ("IN-PROGRESS" . (:foreground "green" :weight bold))
               ("BLOCKED" . (:foreground "red" :weight bold))
               ("DONE" . (:foreground "grey" :weight bold)))))

(setq-default tab-width 4)  ; Set tab width to 4 spaces

;; Hook to apply custom indentation for all major modes
(defun my-global-indent-settings ()
  (setq tab-width 4))

;; Add the custom hook to all programming modes
(add-hook 'prog-mode-hook 'my-global-indent-settings)

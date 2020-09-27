;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; ----------------------------------------------------------------------------
;; Use my preferred keys for escape ,, and the , localleader from spacemacs
(setq-default
   evil-escape-key-sequence ",,"
   evil-escape-delay 0.2
   )
(setq doom-localleader-key ",")
(load! "+keybindings")

(setq! evil-want-Y-yank-to-eol nil)
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; Cosmetics aspects.
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(ignore-errors
  (setq doom-font (font-spec :family "Source Code Pro" :size 14 :weight 'regular)
        doom-variable-pitch-font (font-spec :family "Source Code Pro") ; inherits `doom-font''s :size
        doom-unicode-font (font-spec :family "Source Code Pro" :size 14)
        doom-big-font (font-spec :family "Source Code Pro" :size 23)))
(when IS-MAC
  (ignore-errors
    (setq doom-font (font-spec :family "Source Code Pro" :size 13 :weight 'regular)
          doom-variable-pitch-font (font-spec :family "Source Code Pro") ; inherits `doom-font''s :size
          doom-unicode-font (font-spec :family "Source Code Pro" :size 13)
          doom-big-font (font-spec :family "Source Code Pro" :size 19))))

;;https://framagit.org/gagbo/doom-config/-/blob/master/+local_config_example.eluu0
(setq +pretty-code-fira-font-name "Fira Code Symbol"
      +pretty-code-hasklig-font-name "Hasklig"
      +pretty-code-iosevka-font-name "Iosevka")

;; Use @zzamboni's fancy splash image from
;; https://raw.githubusercontent.com/zzamboni/dot-doom/master/splash.png
(setq fancy-splash-image "~/.doom.d/splash.png")

(setq display-line-numbers-type 'relative)

(add-hook! 'text-mode-hook 'turn-on-auto-fill)
;; From https://discord.com/channels/406534637242810369/406554085794381833/714835271056752640
(setq-hook! 'text-mode-hook fill-column 110)

(setq show-trailing-whitespace t)

(after! all-the-icons
  (setq all-the-icons-scale-factor 1.2))

(after! doom-modeline
  (setq
   doom-modeline-major-mode-color-icon t
   doom-modeline-minor-modes (featurep 'minions)))

(after! doom-themes
  (setq
   doom-neotree-file-icons t
   doom-themes-enable-bold t
   doom-themes-enable-italic t))

(setq
 solarized-use-more-italic t
 solarized-use-variable-pitch t
 solarized-emphasize-indicators t
 solarized-scale-org-headlines t)
;; (load-theme 'solarized-dark t)
;; or advice from FAQ:
(setq doom-theme 'doom-solarized-dark)
;; (setq doom-theme 'agila)
(setq doom-themes-treemacs-enable-variable-pitch nil)

(use-package! dimmer
  :custom
  (dimmer-fraction 0.30)
  ;; buffer exclusion also results in continuous dimming in Rmd files
  ;; (add-to-list 'dimmer-buffer-exclusion-regexps "^\\*R:.*\\*")
  :config
  (dimmer-configure-which-key)
  ;; (dimmer-configure-company-box)
  (dimmer-configure-posframe)
  (dimmer-configure-hydra)
  (dimmer-mode t))

;; Increase Doom's default max number of delimiters of 3 to something more realistic
(setq rainbow-delimiters-max-face-count 6)
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; ESS related customization
(after! ess
  (add-hook! 'prog-mode-hook #'rainbow-delimiters-mode)

  ;; combines https://github.com/fernandomayer/spacemacs/blob/master/private/ess/packages.el and
  ;; https://github.com/MilesMcBain/spacemacs_cfg/blob/master/private/ess/packages.el.
  ;;
  ;; This is a little fishy because it relies on lazy-loading, because
  ;; +keybindings.el already loaded at the top of this file and there this
  ;; function is called.
  (defun tide-insert-pipe ()
    "Insert a %>%"
    (interactive)
    (unless (looking-back "%>%" nil)
      (just-one-space 1)
      (insert "%>%"))
    ;; (newline-and-indent)
    )
  (defun tide-insert-assign ()
    "Insert a %>%"
    (interactive)
    (unless (looking-back "<-" nil)
      (just-one-space 1)
      (insert "<-"))
    ;; (newline-and-indent)
    )

  ;; If I use LSP it is better to let LSP handle lintr. See example in
  ;; https://github.com/hlissner/doom-emacs/issues/2606.
  (setq! ess-use-flymake nil)
  (setq! lsp-ui-doc-enable nil
         lsp-ui-doc-delay 1.5)

  ;; Code indentation copied from my old config.
  ;; Follow Hadley Wickham's R style guide
  (setq
   ess-style 'RStudio
   ess-offset-continued 2
   ess-expression-offset 0)

  (setq comint-move-point-for-output t)

  ;; From https://emacs.readthedocs.io/en/latest/ess__emacs_speaks_statistics.html
  ;; TODO: find out a way to make settings generic so that I can also set ess-inf-R-font-lock-keywords
  (setq ess-R-font-lock-keywords
        '((ess-R-fl-keyword:modifiers  . t)
          (ess-R-fl-keyword:fun-defs   . t)
          (ess-R-fl-keyword:keywords   . t)
          (ess-R-fl-keyword:assign-ops . t)
          (ess-R-fl-keyword:constants  . t)
          (ess-fl-keyword:fun-calls    . t)
          (ess-fl-keyword:numbers      . t)
          (ess-fl-keyword:operators    . t)
          (ess-fl-keyword:delimiters) ; don't because of rainbow delimiters
          (ess-fl-keyword:=            . t)
          (ess-R-fl-keyword:F&T        . t)
          (ess-R-fl-keyword:%op%       . t)))

  ;; ESS buffers should not be cleaned up automatically
  (add-hook 'inferior-ess-mode-hook #'doom-mark-buffer-as-real-h)

  ;; Open ESS R window to the left iso bottom.
  (set-popup-rule! "^\\*R.*\\*$" :side 'left :size 0.38 :select nil :ttl nil :quit nil :modeline t))


;; Ways to disable smartparens for specific characters or fully in a mode.
;; https://github.com/hlissner/doom-emacs/issues/576
(after! smartparens
  ;; this pair change below does not work as good as just disabling overall
  ;; (which i seem to prefer anyway)
  ;; (sp-with-modes 'markdown-mode
  ;;   (sp-local-pair "`" nil))
  ;; (add-hook 'ess-r-mode-hook    #'turn-off-smartparens-mode)
  (add-hook 'markdown-mode-hook #'turn-off-smartparens-mode))

;; Make ESS prettier (from tecosaur's config; link see below)
;; (after! ess-r-mode
;;   (appendq! +pretty-code-symbols
;;             '(:assign "⟵"
;;               :multiply "×"))
;;   (set-pretty-symbols! 'ess-r-mode
;;     ;; Functional
;;     :def "function"
;;     ;; Types
;;     :null "NULL"
;;     :true "TRUE"
;;     :false "FALSE"
;;     :int "int"
;;     :float "float"
;;     :bool "bool"
;;     ;; Flow
;;     :not "!"
;;     :and "&&" :or "||"
;;     :for "for"
;;     :in "%in%"
;;     :return "return"
;;     ;; Other
;;     :assign "<-"
;;     :multiply "%*%"))
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; Activate polymode when loading Rmarkdown documents. Also see
;; https://github.com/MilesMcBain/spacemacs_cfg/blob/master/private/polymode/packages.el
;; for somewhat outdated hints about a personal Rmd-mode
(use-package! polymode
  :commands (R)
)

(after! markdown-mode
  ;; Disable trailing whitespace stripping for Markdown mode
  (add-hook 'markdown-mode-hook #'doom-disable-delete-trailing-whitespace-h)
  ;; Doom adds extra line spacing in markdown documents
  (add-hook! 'markdown-mode-hook :append (setq line-spacing nil)))

;; From Tecosaur's configuration
(add-hook! (gfm-mode markdown-mode) #'mixed-pitch-mode)
;; (add-hook! (gfm-mode markdown-mode) #'visual-line-mode #'turn-off-auto-fill)
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; Material on completing/completion mostly from
;; https://github.com/tecosaur/emacs-config/blob/master/config.org
;;
;; company-show-numbers works with Alt-x.
;; (after! company
;;   (setq company-show-numbers t))
(set-company-backend! '(text-mode
                        markdown-mode
                        gfm-mode)
  '(:seperate company-ispell
              company-files
              company-yasnippet))
;; by default the following also has R-library in there, so this is not needed.
;; (set-company-backend! 'ess-r-mode '(company-R-args company-R-objects company-dabbrev-code :separate))
(setq-default history-length 1000)
(setq-default prescient-history-length 1000)
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; Misc stuff.
;;
;; This helps in aligning operators.
(use-package! evil-lion
  :after evil
  :config (evil-lion-mode))

(setq
  ;; Doom sets substitute-global to t, so /g toggles reversed to muscle memory.
  evil-ex-substitute-global nil

  ;; https://github.com/tecosaur/emacs-config/blob/master/config.org and
  ;; https://discord.com/channels/406534637242810369/695450585758957609/699182292077117440
  evil-want-fine-undo t

  +workspaces-on-switch-project-behavior t
  projectile-project-search-path '("~/projects"))

(add-hook 'treemacs-mode #'treemacs-follow-mode)

(if IS-MAC
  (setq todotxt-file "~/Nextcloud/todo/todo.txt")
  (setq todotxt-file "/c/nlv19419/nextcloud/todo/todo.txt"))

(setq user-full-name "Paul Lemmens"
      user-mail-address "paul.lemmens@gmail.com")
;; ----------------------------------------------------------------------------

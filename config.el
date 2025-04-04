;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Paul Lemmens"
      user-mail-address "paul.lemmens@gmail.com")

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
;; ----------------------------------------------------------------------------
;; Better defaults, for me.

;; Use my preferred keys for escape ,, and the , localleader from spacemacs
(setq-default
   evil-escape-key-sequence ",,"
   evil-escape-delay 0.2
   )
(setq doom-localleader-key ",")
(load! "+keybindings")
;;(load! "+smartparens.el")

(setq! evil-want-Y-yank-to-eol nil)

(setq
  ;; Doom sets substitute-global to t, so /g toggles reversed to muscle memory.
  evil-ex-substitute-global nil

  ;; https://github.com/tecosaur/emacs-config/blob/master/config.org and
  ;; https://discord.com/channels/406534637242810369/695450585758957609/699182292077117440
  evil-want-fine-undo t

  +workspaces-on-switch-project-behavior t

  projectile-project-search-path '("~/projects")
  projectile-ignored-projects '("~/" "/tmp" "~/.emacs.d/.local/straight/repos/")

  magit-diff-hide-trailing-cr-characters t
  )

(defun projectile-ignored-project-function (filepath)
  "Return t if FILEPATH is within any of `projectile-ignored-projects'"
  (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects)))

;; Make sure to start the week on Mondays and set European or ISO date style
(setq! calendar-week-start-day 1)
;; (after! calendar
;;   (calendar-set-date-style 'iso))
;; ----------------------------------------------------------------------------

;; ----------------------------------------------------------------------------
;; Settings for spelling
;;
(add-hook 'spell-fu-mode-hook
  (lambda ()
    (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "nl"))
    (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "en_US"))
    (spell-fu-dictionary-add
     (spell-fu-get-personal-dictionary "nl-personal" "~/dotfiles/aspell.nl.pws"))
    (spell-fu-dictionary-add
     (spell-fu-get-personal-dictionary "en-personal" "~/dotfiles/aspell.en.pws"))
    ))


(use-package! jinx
  :defer t
  :init
  (add-hook 'doom-init-ui-hook #'global-jinx-mode)
  :config
  ;; Use my custom dictionary
  (setq jinx-languages "en_US nl")
  (setq jinx-delay 1.0)
  ;; Extra face(s) to ignore
  (push 'org-inline-src-block
        (alist-get 'org-mode jinx-exclude-faces))
  ;; Take over the relevant bindings.
  (after! ispell
    (global-set-key [remap ispell-word] #'jinx-correct))
  (after! evil-commands
    (global-set-key [remap evil-next-flyspell-error] #'jinx-next)
    (global-set-key [remap evil-prev-flyspell-error] #'jinx-previous))
  ;; I prefer for `point' to end up at the start of the word,
  ;; not just after the end.
  ;; (advice-add 'jinx-next :after (lambda (_) (left-word)))
)


;; From https://github.com/doomemacs/doomemacs/issues/7617.
(after! vertico-multiform ;; if using vertico
  (add-to-list 'vertico-multiform-categories
               '(jinx (vertico-grid-annotate . 25)))
  (vertico-multiform-mode 1))


;; I dislike have spell mode by default. Disable spell-fu-mode in text mode using
;; https://www.reddit.com/r/emacs/comments/mr3urh/comment/gukihia/
;; (remove-hook 'text-mode-hook #'spell-fu-mode)
;; ----------------------------------------------------------------------------

;; ----------------------------------------------------------------------------
;; Cosmetics aspects
;;
;; Set frame size options: fullboth, fullheight, fullwidth, maximized.
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; Using --with-natural-title-bar
;; (from https://notes.alexkehayias.com/emacs-natural-title-bar-with-no-text-in-macos/)
;; (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
;; (add-to-list 'default-frame-alist '(ns-appearance . dark))

;; Open treemacs at startup of Emacs
(add-hook! 'window-setup-hook #'treemacs 'append)

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;;
;; See https://protesilaos.com/codelog/2020-09-05-emacs-note-mixed-font-heights/ for info
;; on :height vs :size.
(when IS-MAC
  (ignore-errors
    (setq doom-font (font-spec :family "Source Code Pro" :size 13 :weight 'regular :weight 'medium)
          doom-variable-pitch-font (font-spec :family "Source Sans Pro" :size 13 :weight 'medium)
          doom-serif-font (font-spec :family "Source Sans Pro" :size 13 :weight 'medium)
          variable-pitch-text (font-spec :family "Source Sans Pro" :size 13 :weight 'medium)
          doom-symbol-font (font-spec :family "Apple Symbols")
          doom-emoji-font (font-spec :family "Apple Color Emoji")
          doom-big-font (font-spec :family "Source Code Pro" :size 19))))

(setq! +zen-text-scale 1.0)

;;https://framagit.org/gagbo/doom-config/-/blob/master/+local_config_example.eluu0
(setq +pretty-code-fira-font-name "Fira Code Symbol"
      +pretty-code-hasklig-font-name "Hasklig"
      +pretty-code-iosevka-font-name "Iosevka")

(setq emojify-emoji-set "emojione-v2.2.6")

;; Use @zzamboni's fancy splash image from
;; https://raw.githubusercontent.com/zzamboni/dot-doom/master/splash.png
(setq fancy-splash-image "~/.doom.d/splash.png")


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'visual)


;; For text modes I (now) want visual-line-mode by default.
;;
(add-hook! 'text-mode-hook #'+word-wrap-mode)
;; From https://discord.com/channels/406534637242810369/406554085794381833/714835271056752640
(setq-hook! 'text-mode-hook
  +word-wrap-extra-indent nil
  +word-wrap-fill-style 'soft)

;; +word-wrap-text-modes sets the modes that should NOT have indentation.
;; +word-wrap-visual-modes does something similar but different.
(add-to-list '+word-wrap-text-modes 'text-mode)
(add-to-list '+word-wrap-visual-modes 'org-mode)
(add-to-list '+word-wrap-visual-modes 'markdown-mode)
(add-to-list '+word-wrap-disabled-modes 'csv-mode)
(add-to-list '+word-wrap-disabled-modes 'org-agenda-mode)
;;
(setq! visual-fill-column-width nil)

;; For prog-mode revert to auto-fill because of code versioning.
;;
(add-hook! 'prog-mode-hook #'turn-on-auto-fill)
(add-hook! 'prog-mode-hook #'+word-wrap-mode)
(setq-hook! 'prog-mode-hook
  +word-wrap-extra-indent 'double
  +word-wrap-fill-style 'auto
  fill-column 110)


(setq show-trailing-whitespace t)


(after! nerd-icons
  :config
  (setq nerd-icons-scale-factor 1.1))


(use-package! doom-modeline
  :config
  (setq doom-modeline-major-mode-color-icon t
        doom-modeline-minor-modes (featurep 'minions)
        ;; Show time and battery in the modeline. From Tecosaur's config.org and
        ;; https://www.lucacambiaghi.com/.doom.d/.
        display-time-format "%Y-%m-%d %k:%M"
        display-time-default-load-average nil
        display-time-24hr-format t
        display-time-day-and-date t)
  (display-time-mode 1)                             ; Enable time in the mode-line
  (display-battery-mode 1)
  )


(use-package! doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(setq
 solarized-use-more-italic t
 solarized-use-variable-pitch t
 solarized-emphasize-indicators t
 solarized-scale-org-headlines t)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-solarized-dark)
(setq doom-theme 'doom-one)
;; (setq doom-theme 'agila)
(setq doom-themes-treemacs-enable-variable-pitch nil)
;; (setq doom-themes-treemacs-theme "doom-colors")


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
;; Configuration for yatodotxt depends on the platform that I'm running on.
(if IS-MAC
  (setq todotxt-file "~/Nextcloud/todo/todo.txt")
  (setq todotxt-file "/c/nlv19419/nextcloud/todo/todo.txt"))
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; ESS related customization
;;
(use-package! ess
  :defer t
  :init
  (add-hook! 'markdown-mode-hook #'turn-on-visual-line-mode)
  (setq-hook! 'inferior-ess-r-mode-hook
    corfu-auto nil)

  :config
  ;; TODO: this should't work according to documentation.
  (setq
   ess-style 'RStudio
   ess-offset-arguments-newline 'open-delim
   ess-offset-continued 'straight
   ess-offset-block 'open-delim
   ess-indent-from-chain-start nil
   )

  ;; Copy stuff to setup proper word wrapping and line breaking from org-mode
  ;; section.
  (setq! visual-fill-column-width nil
         +word-wrap-extra-indent 'double
         +word-wrap-fill-style 'auto)
  (add-to-list '+word-wrap-text-modes 'markdown-mode)

  ;; combines https://github.com/fernandomayer/spacemacs/blob/master/private/ess/packages.el and
  ;; https://github.com/MilesMcBain/spacemacs_cfg/blob/master/private/ess/packages.el.
  ;;
  ;; This is a little fishy because it relies on lazy-loading, because
  ;; +keybindings.el already loaded at the top of this file and there this
  ;; function is called.
  ;; Code indentation copied from my old config. Follow Hadley Wickham's R style guide.
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

  (setq comint-move-point-for-output t)

  ;; From https://emacs.readthedocs.io/en/latest/ess__emacs_speaks_statistics.html
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

  ;; Open ESS R window to the left iso bottom.
  (set-popup-rule! "^\\*R.*\\*$" :side 'left :size 0.38 :select nil :ttl nil :quit nil :modeline t)

  :hook
  ;; ESS buffers should not be cleaned up automatically
  (inferior-ess-mode . doom-mark-buffer-as-real-h)
  (prog-mode . rainbow-delimiters-mode)
  (markdown-mode . +word-wrap-mode)
)


;; Ways to disable smartparens for specific characters or fully in a mode.
;; https://github.com/hlissner/doom-emacs/issues/576
(after! smartparens
  (add-hook 'org-mode-hook      #'turn-off-smartparens-mode)
  (add-hook 'markdown-mode-hook #'turn-off-smartparens-mode))
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; Polymode related configurations
;;
(use-package! quarto-mode
  :mode (("\\.Rmd" . poly-quarto-mode))
)


;; Fix for the weirdness of polymode and lsp. See for more info:
;; https://github.com/polymode/poly-R/issues/34
(setq polymode-lsp-integration nil)


(after! markdown-mode
  ;; Disable trailing whitespace stripping for Markdown mode because trailing
  ;; whitespace might be relevant.
  (add-hook 'markdown-mode-hook #'doom-disable-delete-trailing-whitespace-h)
  ;; Doom adds extra line spacing in markdown documents
  (add-hook! 'markdown-mode-hook :append (setq line-spacing nil)))
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; Material on completing/completion.
(after! dabbrev
  (add-to-list 'dabbrev-ignored-buffer-modes 'markdown-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'org-mode))

(after! corfu
  (setq corfu-auto-delay 0.5
        completion-cycle-threshold 5))
;; possibly interesting: https://github.com/MaxSt/dotfiles/blob/master/emacs.d/config.org#cape

(setq-default history-length 1000)
(setq-default prescient-history-length 1000)
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; Org mode configuration.

;; Supporting functions from https://emacs.stackexchange.com/a/43987 and elsewhere.
(require 'cal-iso)
(defun iso-week-to-time (year week day)
  (pcase-let ((`(,m ,d ,y)
               (calendar-gregorian-from-absolute
                (calendar-iso-to-absolute (list week day year)))))
    (encode-time 0 0 0 d m y)))
(defun iso-beginning-of-week(year week)
  "Convert ISO year, week to elisp time for first day (Monday) of week."
  (iso-week-to-time year week 1))
(defun pl--agile-results-cur-month ()
  "Generates a filename including relative directory for storing org notes in."
  (concat
   "agile_results_"
   (format-time-string "%Y")
   "/month_"
   (format-time-string "%02m" (iso-beginning-of-week
                               (string-to-number (format-time-string "%Y"))
                               (string-to-number (format-time-string "%V"))))
   ".org"))

;; From issue https://github.com/hlissner/doom-emacs/issues/3185
(defadvice! no-errors/+org-inline-image-data-fn (_protocol link _description)
  :override #'+org-inline-image-data-fn
  "Interpret LINK as base64-encoded image data. Ignore all errors."
  (ignore-errors
    (base64-decode-string link)))

;; This snippet is from the org manual.
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
(add-hook 'org-after-todo-statistics-hook #'org-summary-todo)


(use-package! org
  :defer t
  :bind
  (:map org-mode-map ([s-S-M-return] . org-insert-todo-subheading))
  :init
  (setq org-directory "~/Tresorit/org/"
        org-agenda-files (directory-files-recursively org-directory ".org$")
        org-default-notes-file "~/Tresorit/org/todo.org"
        )

  :config
  ;; Keeping multiple newlines of emphasized text together:
  ;; https://emacs.stackexchange.com/a/13828/39252
  (setcar (nthcdr 4 org-emphasis-regexp-components) 5) ; default is 1.
  (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)

  ;; Set up private function to attach fill-column to org-mode specific setting.
  (defun pl/org-mode-setup ()
    (setq! fill-column 110)
  )

  (setq! ;;org-insert-heading-respect-content nil
         org-hide-emphasis-markers t
         org-pretty-entities t
         org-startup-with-inline-images t
         ;; org-outline-path-complete-in-steps nil
         org-refile-allow-creating-parent-nodes 'confirm
         org-refile-targets '((nil :maxlevel . 4)
                              (org-agenda-files :maxlevel . 9))
         org-log-done nil
         org-log-into-drawer t
         org-habit-show-all-today t
         writeroom-mode-line t
         tab-width 8)

  ;; Stuff around word wrapping from Doom's :ui word-wrap.
  (setq! visual-fill-column-width nil
         +word-wrap-extra-indent nil
         +word-wrap-fill-style 'soft)
  (add-to-list '+word-wrap-text-modes 'org-mode)

  ;; Simplify the number of todo keywords compared to Doom's default.
  (setq! org-todo-keywords
         '((sequence
            "TODO(t)"    ; A task that needs doing & is ready to do
            "IDEA(i)"    ; Idea that should be kept on radar for now.
            "DOING(s)"  ; A task that is in progress
            "WAIT(w)"    ; Something external is holding up this task
            "LOOP(r)"    ; A recurring task
            "|"
            "DONE(d)"    ; Task successfully completed
            "CANCEL(c@)" ; Task was cancelled, aborted or is no longer applicable
            "NO(n)"      ; Outcome not completed
            "ELSEW(e)"   ; Task moved to another tracker (most likely todo.txt).
            )
           ;; (sequence
           ;;  "[ ](T)"   ; A task that needs doing
           ;;  "[-](S)"   ; Task is in progress
           ;;  "[?](W)"   ; Task is being held up or paused
           ;;  "|"
           ;;  "[X](D)")  ; Task was completed
           )
         org-todo-keyword-faces
         '(("[-]"    . +org-todo-active)
           ;; ("IDEA"   . +org-todo-active)
           ("[?]"    . +org-todo-onhold)
           ("DOING"  . +org-todo-active)
           ("WAIT"   . +org-todo-onhold)
           ("PROJ"   . +org-todo-project)
           ("OK"     . org-done)
           ("ELSEW"  . org-done)
           ("NO"     . +org-todo-cancel)
           ("CANCEL" . +org-todo-cancel)
           ("KILL"   . +org-todo-cancel)))

  (setq org-capture-templates
        `(
          ("j" "new _j_ournal" plain
           (file ,(pl--agile-results-cur-month))
           (file ,(concat "agile_results_" (format-time-string "%Y") "/day_template.org"))
           :jump-to-captured t
           :immediate-finish t
           :tree-type week
           :empty-lines 1
           )
          ("w" "new _w_eek" entry
           (file ,(pl--agile-results-cur-month))
           (file ,(concat "agile_results_" (format-time-string "%Y") "/week_template.org"))
           :immediate-finish t
           :jump-to-captured t
           :empty-lines 1
           )
          ("m" "new _m_onth" entry
           (file ,(pl--agile-results-cur-month))
           (file ,(concat "agile_results_" (format-time-string "%Y") "/month_template.org"))
           :immediate-finish t
           :jump-to-captured t
           :tree-type month
           :empty-lines 1
           )
          )
        )

  :hook
  (org-mode . +word-wrap-mode)
  (org-mode . +org-pretty-mode)
  (org-mode . solaire-mode)
  (org-mode . writeroom-mode)
  (org-mode . pl/org-mode-setup)

  :custom-face
    (outline-1 ((t (:weight extra-bold :height 1.15))))
    (outline-2 ((t (:weight bold :height 1.1))))
    (outline-3 ((t (:weight bold :height 1.05))))
    ;; (outline-4 ((t (:weight semi-bold :height 1.09))))
    (outline-4 ((t (:weight semi-bold :height 1.0))))
    ;; (outline-5 ((t (:weight semi-bold :height 1.06))))
    ;; (outline-6 ((t (:weight semi-bold :height 1.03))))
    ;; (outline-7 ((t (:weight semi-bold :height 1.03))))
    ;; (outline-8 ((t (:weight semi-bold))))
    ;; (outline-9 ((t (:weight semi-bold))))
    (org-drawer ((t (:weight medium :height 0.9))))
    (org-special-keyword ((t (:weight regular :height 0.9))))
    (org-tag ((t (:weight regular :foreground "#777777" :height 0.9))))
    (org-meta-line ((t (:weight regular :foreground "#444444" :height 0.9))))
    (org-document-info-keyword ((t (:weight regular :foreground "#444444" :height 0.9))))
    (org-table ((t (:height 0.8))))
    (org-quote ((t (:family "Source Sans Pro" :size 11 :weight medium :height 0.9))))
  )


(use-package! org-roam
  :after org
  :init
  (setq! org-roam-directory org-directory
         ;; Learned (rx (or "a" "b")) from https://www.brettwitty.net/exocortex.html
         org-roam-file-exclude-regexp (rx (or ".attach" "4_archive" "agile_results_2021"
                                             "agile_results_2022" "agile_results_2023"
                                             "agile_results_2024"
                                             )))
  :config
  (defun pl/org-roam-directories ()
    (let ((files (mapcar (lambda (f) (file-relative-name f org-roam-directory))
                         (directory-files-recursively org-roam-directory "\\.org$"))))
      (mapcar (lambda (f) (file-name-directory f))
              files)))
  (defun pl/ask-para-location (ARG)
    (completing-read "Choose org file :target : " (pl/org-roam-directories)))

  (setq org-roam-capture-templates
        (quote (
                ("d" "Default" plain "%?"
                 :target (file+head "${pl/ask-para-location}/${slug}.org"
                                    ":properties:
:roam_aliases: %^{Roam aliases}
:project: %^{Project||rai_office|clinops|aequitas}
:area: %^{Area||dsai|consulting_team|rai}
:END:
#+filetags:
#+category: %^{Category}
#+title: ${title}")
                 :unnarrowed t
                 :jump-to-captured t
                 )
                ("j" "new _j_ournal" entry
                 (file "agile_results_2025/day_template.org")
                 :target (file+olp "agile_results_%<%Y>/month_%<%m>.org" ("week %<%V>-%<%Y>"))
                 :empty-lines 2
                 :jump-to-captured t
                 :immediate-finish
                 )
                ("w" "new _w_eek" plain
                 (file "agile_results_2025/week_template.org")
                 :target (file+olp "agile_results_%<%Y>/month_%<%m>.org" ("bottom"))
                 :empty-lines 2
                 :jump-to-captured t
                 :immediate-finish
                 :prepend t
                 )
                ("m" "new _m_onth" plain
                 (file "agile_results_2025/month_template.org")
                 :target (file "agile_results_%<%Y>/month_${2-digit-month}.org")
                 :empty-lines-before 0
                 :empty-lines-after 2
                 :immediate-finish t
                 )
               )
  )))


;; Agenda related config.
(use-package! org-agenda
  :after org
  :hook
  (org-agenda-mode . org-super-agenda-mode)

  :config
  ;; Only show 5 days ahead starting on Monday
  (setq! ;;org-agenda-span 'week
         ;; org-agenda-start-on-weekday 1
         org-agenda-span 5
         org-agenda-start-day "-0d"
         org-agenda-start-on-weekday nil
         org-agenda-block-separator 9472
         org-agenda-compact-blocks t
         org-agenda-prefix-format
         '((agenda . "  %i %?-12t% s")
           ;; (todo . " %i %?-12:c ")
           ;; (tags . " %i %?-20:c ")
           (todo . "   %i        ")
           (tags . "   %i        ")
           (search . "   %i        "))
         org-agenda-category-icon-alist
         `(
           ("rai" ,(list (nerd-icons-faicon "nf-fa-balance_scale")) nil nil :ascent center)
           ;; ("clindev" ,(list (nerd-icons-faicon "nf-fa-syringe")) nil nil :ascent center)
           ;; ("qre" ,(list (nerd-icons-faicon "nf-fa-quality_high")) nil nil :ascent center)
           ("middegaal" ,(list (nerd-icons-mdicon "nf-md-family_tree")) nil nil :ascent center)
           )
         )

  (setq! org-agenda-custom-commands
         '(("u" "Super view"
            ((org-ql-block '(and (tags "policy") (tags "memorize"))
                           ((org-ql-block-header "Take to the heart:")
                            (org-super-agenda-groups
                             '((:name none)
                               (:auto-category t)))))
             ;; Hack to create room/space between quality policy and calendar:
             (alltodo "" ((org-agenda-overriding-header "")
                          (org-super-agenda-groups
                           '(
                             (:name none
                              :discard (:anything t))
                             )
                           )))
             (agenda  "" ((org-super-agenda-groups
                          '(
                            (:name none ; "⏰ Calendar"  ; Optionally specify section name
                             :time-grid t)        ; Items that appear on the time grid
                            (:name "Habits" :habit t)
                           ))))
             (alltodo "" ((org-agenda-overriding-header "")
                          (org-super-agenda-groups
                          '(
                            (:name "Today's outcomes"
                             :and (:tag "outcomes" :tag "day"))
                            (:name "Three for the week"
                             :and (:tag "outcomes" :tag "week"))
                            (:name "Monthly outcomes"
                             :and (:tag "outcomes" :tag "month"))
                            ;; (:name "Year outcomes"
                            ;;  :and (:tag "outcomes" :tag "year"))
                            ;; (:auto-property "project")
                            (:discard (:todo "IDEA"))
                            (:discard (:tag "policy"))
                            (:discard (:habit t))
                            (:auto-category t)
                            ))))))
           ("zt" "Tags view"
            ((alltodo "" (;;(org-agenda-overriding-header "")
                          (org-super-agenda-groups
                           '(;; Each group has an implicit boolean OR operator between its selectors.
                             (:discard (:tag ("ATTACH" "outcomes")))
                             (:discard (:todo ("ELSEW" "IDEA")))
                             (:name "Tags"
                              :auto-tags)
                             ;; :and (:deadline past :todo ("TODO" "WAITING" "HOLD" "NEXT"))
                             ;; :face (:background "#7f1b19")
                             ))))))
           ("zp" "Projects view"
            ((alltodo "" ((org-super-agenda-groups
                           '(
                             (:discard (:tag ("ATTACH" "outcomes")))
                             (:discard (:todo ("ELSEW" "IDEA")))
                             (:name "Project"
                              :auto-property "project")
                             (:discard (:anything t))
                             ))))))
           ("za" "Areas view"
            ((alltodo "" ((org-super-agenda-groups
                           '(
                             (:discard (:tag ("ATTACH" "outcomes")))
                             (:discard (:todo ("ELSEW" "IDEA")))
                             (:name "Area"
                              :auto-property "area")
                             (:discard (:anything t))
                             ))))))
           ("zc" "Categories view"
            ((alltodo "" ((org-super-agenda-groups
                           '(
                             (:discard (:tag ("ATTACH" "outcomes")))
                             (:discard (:todo ("ELSEW" "IDEA")))
                             (:name "Category"
                              :auto-category t)
                             (:discard (:anything t))
                             ))))))
           ("zi" "Ideas"
            ((alltodo "" ((org-super-agenda-groups
                           '(
                             (:discard (:tag ("ATTACH" "outcomes")))
                             (:name "Idea"
                              :todo "IDEA")
                             (:discard (:anything t))
                             ))))))
           )
         )


  ;; super-agenda related config.
  (setq! org-super-agenda-header-map nil
         org-super-agenda-header-separator "\n"
         org-super-agenda-header-prefix "\n  "
         org-super-agenda-final-group-separator "\n"
         org-super-agenda-groups
         '(
           (:name "Habits" :habit t)
           (:name "Monthly outcomes"
            ;; :face (:family "Source Sans Pro" :height 150 :overline)
            :and (:tag "outcomes" :tag "month"))
           (:name "Three for the week"
            :and (:tag "outcomes" :tag "week"))
           (:name "Today's outcomes"
            :and (:tag "outcomes" :tag "day"))
           ;; (:auto-property "project")
           (:discard (:todo "IDEA"))
           (:auto-category t)
           ;; (:auto-outline-path t)
           )
         )
  )


(use-package! org-modern
  :defer t
  :after org
  :hook (org-mode . org-modern-mode)
  :custom-face
  (org-modern-date-active ((t (:family "Source Sans Pro" :foreground "#bbc2cf" :background "#282c34" :weight medium :height 1.15))))
  (org-modern-time-active ((t (:family "Source Sans Pro" :foreground "#bbc2cf" :background "#282c34" :weight medium :height 1.3 :DistantForeground nil))))
  (org-modern-date-inactive ((t (:inherit org-modern-date-active))))
  (org-modern-time-inactive ((t (:inherit org-modern-date-inactive))))
  (org-modern-label ((t (:family "Source Sans Pro" :weight medium))))
  (org-modern-done ((t (:inherit org-modern-label :foreground "#5B6268" :background: "#282c34" :height 1.1))))
  (org-modern-tag ((t (:inherit org-drawer :foreground "#5B6268" :height 0.9))))
  ;; (org-level-1 ((t (:height 1.4 :inherit outline-1)))))
  :config
  (setq org-modern-replace-stars '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
        org-modern-star 'replace
        org-modern-table nil
        org-modern-timestamp nil
        org-modern-table-vertical 1
        org-modern-table-horizontal 0.2
        org-modern-list '((43 . "➤")
                          (45 . "–")
                          (42 . "•"))
        org-modern-todo-faces
        '(("TODO" :inverse-video t :inherit org-todo)
          ("PROJ" :inverse-video t :inherit +org-todo-project)
          ("STRT" :inverse-video t :inherit +org-todo-active)
          ("[-]"  :inverse-video t :inherit +org-todo-active)
          ("HOLD" :inverse-video t :inherit +org-todo-onhold)
          ("WAIT" :inverse-video t :inherit +org-todo-onhold)
          ("[?]"  :inverse-video t :inherit +org-todo-onhold)
          ("KILL" :inverse-video t :inherit +org-todo-cancel)
          ("NO"   :inverse-video t :inherit +org-todo-cancel))
        org-modern-footnote
        (cons nil (cadr org-script-display))
        org-modern-block-fringe nil
        org-modern-block-name
        '((t . t)
          ("src" "»" "«")
          ("example" "»–" "–«")
          ("quote" "❝" "❞")
          ("export" "⏩" "⏪"))
        org-modern-checkbox nil
        org-modern-progress nil
        org-modern-priority nil
        org-modern-horizontal-rule (make-string 36 ?─)
        org-modern-keyword
        '((t . t)
          ("title" . "󰗴")
          ("subtitle" . "󰨖")
          ("author" . "󱠀")
          ("email" . #("" 0 1 (display (raise -0.14))))
          ("date" . "")
          ("property" . "☸")
          ("options" . "󱑜")
          ("startup" . "󱪤")
          ;; ("macro" . "𝓜")
          ("bind" . #("" 0 1 (display (raise -0.1))))
          ("bibliography" . "")
          ("print_bibliography" . #("" 0 1 (display (raise -0.1))))
          ("cite_export" . "")
          ("print_glossary" . #("ᴬᶻ" 0 1 (display (raise -0.1))))
          ("glossary_sources" . #("" 0 1 (display (raise -0.14))))
          ("include" . "⇤")
          ("setupfile" . "⇚")
          ("html_head" . "🅷")
          ("html" . "🅗")
          ("latex_class" . "🄻")
          ("latex_class_options" . #("🄻" 1 2 (display (raise -0.14))))
          ("latex_header" . "🅻")
          ("latex_header_extra" . "🅻⁺")
          ("latex" . "🅛")
          ("beamer_theme" . "🄱")
          ("beamer_color_theme" . #("🄱" 1 2 (display (raise -0.12))))
          ("beamer_font_theme" . "🄱")
          ("beamer_header" . "🅱")
          ("beamer" . "🅑")
          ("attr_latex" . "🄛")
          ("attr_html" . "🄗")
          ("attr_org" . "⒪")
          ("call" . #("" 0 1 (display (raise -0.15))))
          ("name" . "⁍")
          ("header" . "›")
          ("caption" . "☰")
          ("results" . "󰒠"))))


(use-package! org-sidebar
  :defer t
  :after org
  :config
  (setq org-sidebar-tree-jump-fn #'org-sidebar-tree-jump-source)
)


(use-package! ob-mermaid
  :defer t
  :after org
  :config
  (setq ob-mermaid-cli-path "/usr/local/bin/mmdc")
  (add-to-list 'org-babel-load-languages '(mermaid . t))
)


;; With inspiration from: https://www.reddit.com/r/emacs/comments/145a3wk/orgdownload_doesnt_add_file_url_to_image_links/
;; Adapted from https://emacs.stackexchange.com/a/79298. Also see
;; https://github.com/abo-abo/org-download/issues/46#issuecomment-281018423
;; for alternative method and the first link's accepted answer for a file
;; system based solution.
(after! org-download
  ;; (setq-local org-attach-id-dir (concat (file-name-sans-extension (buffer-file-name)) "_attach"))
  (setq org-download-image-org-width 400)
)


;; Use org-roam-ui.
(use-package! websocket
    :after org-roam
)


(use-package! org-roam-ui
    :defer t
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t)
)


(after! org-brain
  (setq! org-brain-path org-directory
         org-brain-include-file-entries t
         org-brain-file-entries-use-title t)
)
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
(after! python
  (set-popup-rule! "^\\*Python\\*$" :side 'left :size 0.38 :select nil :ttl nil :quit nil :modeline t))
;; ----------------------------------------------------------------------------


;; ----------------------------------------------------------------------------
;; Misc stuff.
;;
;; This helps in aligning operators.
(use-package! evil-lion
  :after evil
  :config (evil-lion-mode))


(after! treemacs
  (setq treemacs-show-hidden-files nil
        treemacs-follow-after-init t
        treemacs-project-follow-cleanup t)
  (progn
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)))


(use-package! casual
  :after dired
  :config
  (map! :map dired-mode-map
        :localleader
        :desc "casual-dired" :n "c" #'casual-dired-tmenu))
;; ----------------------------------------------------------------------------

;; ----------------------------------------------------------------------------
;; Series of adjustments from tecosaur's config.
;;
;; Chop some superfluous words in which-key popups
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))

;; ----------------------------------------------------------------------------

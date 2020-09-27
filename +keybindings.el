;;; ~/dotfiles/wsl/wsl_dotfiles/doom.d/+keybindings.el -*- lexical-binding: t; -*-

;; Key bindings copied from
;; https://github.com/robbert-vdh/dotfiles/blob/master/user/emacs/.config/doom/%2Bbindings.el
(map!
 ;; :nv "SPC /" #'+default/search-project
 (:leader
   :desc "Search project" "/" #'+default/search-project
   (:prefix "b"
     :desc "Revert"            "R"  #'revert-buffer))

 ;; Copying from https://github.com/syl20bnr/spacemacs/blob/26b8fe0c317915b622825877eb5e5bdae88fb2b2/layers/%2Bsource-control/git/packages.el#L354
 (:map with-editor-mode-map
   :n ", ,"  #'with-editor-finish
   :n ", c"  #'with-editor-finish
   :n ", a"  #'with-editor-cancel
   :n ", k"  #'with-editor-cancel)

 (:after evil
   (:leader
     (:prefix "w"
       :desc "Vertical split"   "/"  #'evil-window-vsplit
       :desc "Horizontal split" "-"  #'evil-window-split)
     (:prefix "c"
       :desc "Comment/uncomment" "l" #'evilnc-comment-or-uncomment-lines))

   ;; https://discordapp.com/channels/406534637242810369/406554085794381833/646966897014734858
   (:map evil-insert-state-map
     :g "C-y" #'evil-paste-before))

 ;; Attempt quicker selection of specific windows like I had for Spacemacs.
 ;; Then rebind workspace selection to a Ctrl-Alt shortcut key.
 (:after winum
   :g "M-1"   #'winum-select-window-1
   :g "M-2"   #'winum-select-window-2
   :g "M-3"   #'winum-select-window-3
   :g "M-4"   #'winum-select-window-4
   :g "M-5"   #'winum-select-window-5
   :g "M-6"   #'winum-select-window-6
   :g "M-7"   #'winum-select-window-7
   :g "M-8"   #'winum-select-window-8
   :g "M-9"   #'winum-select-window-9
   :g "M-0"   #'winum-select-window-0
   (:when IS-MAC
     :n "s-1"   #'winum-select-window-1
     :n "s-2"   #'winum-select-window-2
     :n "s-3"   #'winum-select-window-3
     :n "s-4"   #'winum-select-window-4
     :n "s-5"   #'winum-select-window-5
     :n "s-6"   #'winum-select-window-6
     :n "s-7"   #'winum-select-window-7
     :n "s-8"   #'winum-select-window-8
     :n "s-9"   #'winum-select-window-9
     :n "s-0"   #'winum-select-window-0))

 (:after ess
   (:map ess-r-mode-map
     ;; :i     "M--" #'ess-insert-assign
     :i     "M--" #'tide-insert-assign
     :i     "M-+" #'tide-insert-pipe
     :i     "M-p" #'tide-insert-pipe
     :i     "RET" #'ess-indent-new-comment-line
     )

   (:map inferior-ess-r-mode-map
     :nvio  "C-k" #'comint-previous-input
     :nvio  "C-j" #'comint-next-input
     :i     "M-+" #'tide-insert-pipe
     :i     "M-p" #'tide-insert-pipe
     :i     "M--" #'tide-insert-assign
     ;; :i     "M--" #'ess-insert-assign
     )

   (:map ess-roxy-mode-map
     :i     "RET" #'ess-indent-new-comment-line
     ;; below two "prettier" versions that should work, but don't (for me)
     ;; [remap newline]            #'ess-indent-new-comment-line
     ;; [remap newline-and-indent] #'ess-indent-new-comment-line
    )

   ;; Assign Ctrl-Up/Down to search in ESS history based on string entered. See
   ;; https://ess.r-project.org/Manual/ess.html#Command-History and
   ;; https://stat.ethz.ch/pipermail/ess-help/2007-June/004150.html
   (:map comint-mode-map
     :nviom [C-up]   #'comint-previous-matching-input-from-input
     :nviom [C-down] #'comint-next-matching-input-from-input
     ;; I want to have C-j/k to be next/prev command in normal and insert state,
     ;; but for normal I can't get it to work:
     :nviom "C-k"    #'comint-previous-input
     :nviom "C-j"    #'comint-next-input))

 (:after csv-mode
   (:leader
     (:prefix-map ("m" . "major mode")
       (:prefix ("c" . "csv-mode")
         :desc "align fields"      "a"  #'csv-align-fields
         :desc "kill fields"       "d"  #'csv-kill-fields
         :desc "toggle invisible"  "i"  #'csv-toggle-invisibility
         :desc "forward field"     "n"  #'csv-forward-field
         :desc "backward field"    "p"  #'csv-backward-field
         :desc "reverse region"    "r"  #'csv-reverse-region
         :desc "sort fields"       "sf" #'csv-sort-fields
         :desc "sort num. fields"  "sn" #'csv-sort-numeric-fields
         :desc "toggle desc."      "so" #'csv-toggle-descending
         :desc "transpose"         "t"  #'csv-transpose
         :desc "unalign fields"    "u"  #'csv-unalign-fields
         :desc "yank fields"       "vf" #'csv-yank-fields
         :desc "yank as table"     "vt" #'csv-yank-as-new-table)))))

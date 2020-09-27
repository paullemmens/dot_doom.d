;;; .doom.d/modules/tools/yatodotxt/config.el -*- lexical-binding: t; -*-
;;;
(use-package! todotxt
  :commands (todotxt-mode)
  :demand t
  ;; :mode implies :defer
  ;; :mode (("todo\\.txt" . todotxt-mode)
  ;;        ("done\\.txt" . todotxt-mode))
  :config
  (if IS-MAC
   (setq todotxt-file "~/Dropbox/todo/todo.txt")
   (setq todotxt-file "/c/nlv19419/Dropbox/todo/todo.txt")
  )
)

(map!
 (:after todotxt
   (:leader
     ;; (:prefix-map ("m" . "eXtra")
     (:prefix-map ("o" . "open")
       (:prefix ("x" . "todo.txt")
         :desc "Open todo.txt"            "o"  #'todotxt
         :desc "Show all"                 "l"  #'todotxt-unhide-all
         :desc "list Incomplete"          "i"  #'todotxt-show-incomplete
         :desc "Complete item"            "x"  #'todotxt-complete-toggle
         :desc "Nuke item"                "N"  #'todotxt-nuke-item
         :desc "Add item"                 "a"  #'todotxt-add-item-any-buffer
         :desc "Quit"                     "q"  #'todotxt-bury
         :desc "Add priority"             "r"  #'todotxt-add-priority
         :desc "Add priority"             "p"  #'todotxt-add-priority
         :desc "Archive completed items"  "A"  #'todotxt-archive
         :desc "Edit item"                "e"  #'todotxt-edit-item
         :desc "Tag item"                 "t"  #'todotxt-tag-item
         :desc "Due date"                 "d"  #'todotxt-add-due-date
         :desc "Filter for ..."           "/"  #'todotxt-filter-for
         :desc "Clear filter"             "\\" #'todotxt-filter-out
         :desc "Revert the buffer"        "g"  #'todotxt-revert
         :desc "Save"                     "s"  #'save-buffer
         :desc "Undo"                     "u"  #'todotxt-undo)))))

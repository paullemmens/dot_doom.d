;;; .doom.d/modules/tools/yatodotxt/config.el -*- lexical-binding: t; -*-
;;;
(defun +todotxt-init-keybinds-h ()
  "Sets up local leader keybindings for todotxt-mode."
  (map! :map todotxt-mode-map
        :localleader
        :desc "Show all"                 :n "l"  #'todotxt-unhide-all
        :desc "list Incomplete"          :n "i"  #'todotxt-show-incomplete
        :desc "Complete item"            :n "x"  #'todotxt-complete-toggle
        :desc "Nuke item"                :n "N"  #'todotxt-nuke-item
        :desc "Add item"                 :n "a"  #'todotxt-add-item-any-buffer
        :desc "Quit"                     :n "q"  #'todotxt-bury
        :desc "Add priority"             :n "r"  #'todotxt-add-priority
        :desc "Add priority"             :n "p"  #'todotxt-add-priority
        :desc "Archive completed items"  :n "A"  #'todotxt-archive
        :desc "Edit item"                :n "e"  #'todotxt-edit-item
        :desc "Tag item"                 :n "t"  #'todotxt-tag-item
        :desc "Due date"                 :n "d"  #'todotxt-add-due-date
        :desc "Filter for ..."           :n "/"  #'todotxt-filter-for
        :desc "Clear filter"             :n "\\" #'todotxt-filter-out
        :desc "Save"                     :n "s"  #'save-buffer
        :desc "Undo"                     :n "u"  #'todotxt-undo)
  )

(use-package! todotxt
  :commands (todotxt-mode)
  :demand t
  ;; :mode implies :defer
  :mode (("todo\\.txt" . todotxt-mode)
         ("done\\.txt" . todotxt-mode))

  :config
  (if IS-MAC
   (setq todotxt-file "~/Dropbox/todo/todo.txt")
   (setq todotxt-file "/c/nlv19419/Dropbox/todo/todo.txt")
  )

   ;; This gives a nice submenu for the todotxt mode.
  :init
  (map!
   (:leader :desc "todo.txt"
            (:prefix "m"
                     (:prefix ("t" . "todotxt")
                      :desc "Open todo.txt"    "o" #'todotxt
                      :desc "Quit"             "q" #'todotxt-bury
                      :desc "Add todo item"    "a" #'todotxt-add-item-any-buffer))))
  (add-hook! 'todotxt-mode-hook #'+todotxt-init-keybinds-h)
 )

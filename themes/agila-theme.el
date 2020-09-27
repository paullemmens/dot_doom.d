;;; agila-theme.el --- A base16-inspired colorscheme

;; Author: Alex Smith <xeals@pm.me>
;; Version: 0
;; Package-Requires: ((base16-theme "2.0"))
;; Keywords: theme

;; This file is not part of GNU Emacs.

;;; License:
;; Unlicense.

;;; Commentary:
;; Base16: (https://github.com/chriskempson/base16)

;;; Code:

(require 'base16-theme)

(defvar agila-colors
'(:base00 "#1a1e24"
  :base01 "#252b33"
  :base02 "#252a34"
  :base03 "#3b4453"
  :base04 "#505964"
  :base05 "#cdd3df"
  :base06 "#dae0ed"
  :base07 "#cfcfcf"
  :base08 "#ee6165"
  :base09 "#fb924c"
  :base0A "#fac751"
  :base0B "#91b859"
  :base0C "#5bb3b4"
  :base0D "#6398cf"
  :base0E "#c28aa3"
  :base0F "#926b3e")
"All colors for Agila are defined here.")

;; Define the theme
(deftheme agila)

;; Add all the faces to the theme
(base16-theme-define 'agila agila-colors)

;; Mark the theme as provided
(provide-theme 'agila)

;; Make sure the theme is actually loaded
;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide 'agila-theme)

;;; agila-theme.el ends here

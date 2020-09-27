;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)
(package! solarized-theme)
(package! evil-lion)
(package! base16-theme)

(package! polymode :recipe
  (:host github :repo "polymode/polymode"))
(package! poly-markdown :recipe
  (:host github :repo "polymode/poly-markdown"))
(package! poly-R :recipe
  (:host github :repo "polymode/poly-R"))
(package! poly-org :recipe
  (:host github :repo "polymode/poly-org"))
;; (package! poly-rst :recipe
;;   (:host github :repo "polymode/poly-rst"))
(package! poly-noweb :recipe
  (:host github :repo "polymode/poly-noweb"))

(package! dimmer :recipe
  (:host github :repo "gonewest818/dimmer.el"))
(package! csv-mode)

(provide 'packageconf)

(use-package doom-themes
  :config (load-theme 'doom-sourcerer))

(use-package evil
  :config (evil-mode 1))

(evil-define-key 'normal slime-mode-map ",cc" 'slime-compile-defun)

(use-package evil-cleverparens
  :hook ((lisp-mode . evil-cleverparens-mode)
	 (emacs-lisp-mode . evil-cleverparens-mode)))

(evil-define-key 'visual 'prog-mode-map ";" 'comment-or-uncomment-region)

(use-package ledger-mode
  :custom (ledger-post-auto-adjust-amount t))

(use-package slime
  :custom (inferior-lisp-program "/usr/bin/sbcl"))

(use-package slime-autoloads
  :after slime
  :custom (slime-contribs (append '(slime-fancy) slime-contribs)))

(use-package god-mode)

(use-package evil-god-state
  :config
  (evil-define-key 'normal global-map "," 'evil-execute-in-god-state))

(use-package org
  :bind (("C-c c" . org-capture)
	 ("C-c a" . org-agenda))
  :hook (org-mode . auto-fill-mode)
  :custom
  (org-default-notes-file "~/org/todo.org")
  (org-capture-templates `(("t" "Task" entry
			    (file+headline (lambda () (if (projectile-project-root)
							  (concat (projectile-project-root) "todo.org")
							org-default-notes-file))
					   "Tasks")
			    "* TODO %?\n  %u\n  %i\n")
			   ("a" "Appointment" entry
			    (file+headline "" "Appointments")
			    "* TODO %?\n  %^T\n  %i\n %^{Location}p\n ")))
  (org-agenda-todo-ignore-timestamp 'all)
  (org-agenda-todo-ignore-deadlines 'near)
  (org-agenda-todo-ignore-scheduled 't)
  (org-agenda-todo-list-sublevels nil))

(use-package projectile
  :after org
  :bind
  ("C-c p" . projectile-command-map)
  :config (projectile-mode +1))

(use-package eshell
  :bind ("C-c e" . eshell))

;; (use-package paredit
;;   :hook ((lisp-mode emacs-lisp-mode geiser-mode) . paredit-mode))

(use-package clojure-mode)
(use-package cider)

(defun insert-char-not-at-point (c)
  "Only inserts char C if C is not at point, moving point forward when done"
  (if (and (< (point) (point-max)) (char-equal c (char-after)))
      (forward-char)
    (insert c)))

(use-package ruby-electric
  :commands ruby-electric-mode
  :hook (ruby-mode . ruby-electric-mode)
  :custom (use-my-ruby-close-brace t)
  :bind (:map ruby-electric-mode-map
	      ("}" . #'my-ruby-close-squirrely-brace)
	      (")" . #'my-ruby-close-paren)
	      ("]" . #'my-ruby-close-square-bracket)) 
  :init
  (defun my-ruby-close-squirrely-brace ()
    "When ruby-close-brace is called, don't insert brace if one already exists on the line."
    (interactive)
    (if (not use-my-ruby-close-brace)
	(insert ?})
      (insert-char-not-at-point ?})))
  (defun my-ruby-close-paren ()
    "When ruby-close-brace is called, don't insert brace if one already exists on the line."
    (interactive)
    (if (not use-my-ruby-close-brace)
	(insert ?\))
      (insert-char-not-at-point ?\))))
  (defun my-ruby-close-square-bracket ()
    "When ruby-close-brace is called, don't insert brace if one already exists on the line."
    (interactive)
    (if (not use-my-ruby-close-brace)
	(insert ?\])
      (insert-char-not-at-point ?\]))))

(use-package inf-ruby
  :commands inf-ruby-minor-mode
  :hook (ruby-mode . inf-ruby-minor-mode))

(use-package lilypond-mode
  :hook (LilyPond-mode #'turn-on-font-lock)
  :mode ("\\.ly$" . LilyPond-mode))

(use-package magit
  :bind ("C-c g" . magit-status))

(provide 'start)

(progn
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (add-hook 'prog-mode-hook 'linum-mode))

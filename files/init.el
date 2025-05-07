;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Disable GUI elements
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(setq visible-bell t)

;; Set directory for autosaving
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

;; Keybind for compile
(global-set-key (kbd "C-x c") 'compile)

;; Keybind for browse the web with eww
(global-set-key (kbd "C-x w") 'eww)

;; RETURN will follow links in org-mode files
(setq org-return-follows-link t)

;; Line numbers
(column-number-mode)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook term-mode-hook eshell-mode-hook vterm-mode-hook eww-mode-hook gptel-mode-hook ))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Evil mode
(use-package evil
  :config
  (setq evil-want-integration t
        evil-want-keybindings nil
        evil-want-C-i-jump nil)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-[") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join))

;; Disable Evil mode in specific non-editing modes
(dolist (mode '(vterm-mode
                eshell-mode
                term-mode
                shell-mode
                dired-mode))
  (add-to-list 'evil-emacs-state-modes mode))

;; Org mode
(use-package org
  :config
  (setq org-agenda-files '("~/org/agenda.org")))

;; Disable company-mode in Org mode
(add-hook 'org-mode-hook (lambda () (company-mode -1)))

;; Web-mode & PHP-mode
(use-package web-mode
  :mode ("\.html\'" "\.css\'" "\.js\'" "\.jsx\'")
  :config
  (setq web-mode-enable-css-colorization t
        web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

(use-package php-mode
  :mode "\.php\'")

;; LSP mode
(use-package lsp-mode
  :hook ((php-mode . lsp)
         (web-mode . (lambda ()
                       (when (member (file-name-extension buffer-file-name) '("js" "jsx"))
                         (lsp)))))
  :config
  (setq lsp-prefer-flymake nil
        lsp-enable-file-watchers nil))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

;; Disable startup screen and logo
;;(setq inhibit-startup-screen t
;;      inhibit-splash-screen t
;;      initial-scratch-message nil)

;; Vterm
(use-package vterm
  :bind ("C-x v" . vterm)
  :hook (vterm-mode . (lambda () (company-mode -1))))

(defun split-window-below-80-20 ()
  "Split the window into 80% top and 20% bottom."
  (interactive)
  (split-window-below)
  (let ((new-height (round (* 0.8 (frame-text-lines)))))
    (shrink-window (- (window-total-height) new-height))))

;; split 80-20
(global-set-key (kbd "C-x 4") 'split-window-below-80-20)

;; winner mode
(use-package winner
  :ensure nil
  :hook after-init
  :commands (winner-undo winner-redo)
  :custom
  (winner-boring-buffers '("*Completions*" "*Help*" "*Apropos*"
			   "*Buffer List*" "*info*" "*Compile-Log*")))
;; move between buffers with vim keyvinds
  (global-set-key (kbd "C-c h") 'windmove-left)
  (global-set-key (kbd "C-c l") 'windmove-right)
  (global-set-key (kbd "C-c k") 'windmove-up)
  (global-set-key (kbd "C-c j") 'windmove-down)

;; Projectile
(use-package projectile
  :config
  (projectile-mode 1)
  (setq projectile-project-search-path '("~/projects")
        projectile-completion-system 'ivy)
  :bind-keymap ("C-c p" . projectile-command-map))

;; Company
(use-package company
  :config
  (global-company-mode)
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection)
         :map company-mode-map
              ("<tab>" . company-indent-or-complete-common)))

;; Ivy
(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        enable-recursive-minibuffers t)
  :bind (:map ivy-minibuffer-map
              ("C-l" . ivy-alt-done)
              ("C-j" . ivy-next-line)
              ("C-k" . ivy-previous-line)))

;; Deepseek api with gptel
(use-package gptel
  :ensure t
  :config
  (defun read-gptel-api-key ()
    "read API key from a file."
    (with-temp-buffer
      (insert-file-contents "~/location/file")
      (string-trim (buffer-string))))

  (setq gptel-api-key (read-gptel-api-key))
  (setq gptel-model 'gpt-4o)  

  (global-set-key (kbd "C-c g") 'gptel-send)
)
;; doom
 (use-package doom-themes
  :config
  ;; Load the theme (you can change 'doom-one' to any other available theme)
  (load-theme 'doom-one t)

  ;; Enable Doom-style bold and italic globally
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)

  ;; Corrects (and improves) org-mode's native fontification
  (doom-themes-org-config))
 
;; Custom functions
(defun split-window-75-4term ()
  (interactive)
  (split-window-below)
  (let ((height (window-total-height)))
    (set-window-margins (next-window) 0)
    (enlarge-window (- height (* 2 (/ height 4))))))

;; Custom variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-battery-mode t)
 '(package-selected-packages
   '(gptel web-mode vterm projectile php-mode lsp-ui ivy evil compat company)))

(provide 'init)
;;; init.el ends here

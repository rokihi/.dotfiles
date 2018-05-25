(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (misterioso)))
 '(inhibit-startup-screen t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "CadetBlue1")))))


;; package管理
(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

;; ;; package自動インストール
(package-initialize)
(require 'cl)
(defvar installing-package-list
  '(
    ;; ここに使っているパッケージを書く。
    undo-tree
    auto-complete
    python-mode
    flymake-python-pyflakes
    py-autopep8
    ))
(let ((not-installed (loop for x in installing-package-list
                            when (not (package-installed-p x))
                            collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
        (package-install pkg))))

;; color theme
;(load-theme 'monokai t)
;;cursor
;(set-cursor-color "indianred")

(set-language-environment 'Japanese)    ; 日本語環境
(set-default-coding-systems 'utf-8-unix)    ; UTF-8 が基本
(set-terminal-coding-system 'utf-8-unix)    ; emacs -nw も文字化けしない
(setq default-file-name-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
(prefer-coding-system 'utf-8-unix)
;; Japanese font
(set-fontset-font t 'japanese-jisx0208 (font-spec :family "TakaoExGothic"))
;;(set-fontset-font t 'japanese-jisx0208 (font-spec :family "NotoSansCJKJP"))

;; スクリーンの最大化
(set-frame-parameter nil 'fullscreen 'maximized)

;; バックスペースの設定
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))
;(keyboard-translate ?\C-h ?\C-?)

;; ウィンドウを透明にする
;; アクティブウィンドウ／非アクティブウィンドウ（alphaの値で透明度を指定）
(add-to-list 'default-frame-alist '(alpha . (0.88 0.85)))

;; メニューバーを消す
;;(menu-bar-mode -1)
;; ツールバーを消す
(tool-bar-mode -1)

;; line numberの表示
;(require 'linum)
(global-linum-mode 1)
(setq linum-format "%4d ")

;; tabサイズ
;(setq default-tab-width 4) 
;; タブ文字ではなくスペースを使う
(setq-default tab-width 4 indent-tabs-mode nil)

;; 対応する括弧をハイライト
(show-paren-mode 1)
;; リージョンのハイライト
(transient-mark-mode 1)
;; カーソル行をハイライト
;;(global-hl-line-mode t)

;; 大文字・小文字を区別しない
(setq case-fold-search t)

;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)

;; タイトルパーにファイルのフルパスを表示する
(setq frame-title-format "%f")

;; シフト＋矢印で範囲選択
;;(setq pc-select-selection-keys-only t)
;;(pc-selection-mode 1)

;; active window move
(global-set-key (kbd "<C-left>")  'windmove-left)
(global-set-key (kbd "<C-down>")  'windmove-down)
(global-set-key (kbd "<C-up>")    'windmove-up)
(global-set-key (kbd "<C-right>") 'windmove-right)

;;; *.~ とかのバックアップファイルを作らない
;;(setq make-backup-files nil)
;;; .#* とかのバックアップファイルを作らない
;;(setq auto-save-default nil)
;; バックアップとオートセーブファイルを~/.emacs.d/backups/へ集める
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))


;; 選択範囲ない場合はc-wで一語削除
(defun backward-kill-line ()
  "Kill text between line beginning and point"
  (interactive)
  (kill-region (line-beginning-position) (point)))
(defun kill-word-or-region ()
  "Kill word backwards, kill region if there is an active one"
  (interactive)
  (if (use-region-p)
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))
(global-set-key (kbd "\C-u") 'backward-kill-line)
(global-set-key (kbd "\C-w") 'kill-word-or-region)
; 元のキーバインドを C-c に追いやる
(global-set-key (kbd "\C-c\C-u") 'universal-argument)
(global-set-key (kbd "\C-c\C-w") 'kill-region)


;; 1行コメントアウト
(defun one-line-comment ()
  (interactive)
  (if (use-region-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
(save-excursion
    (beginning-of-line)
    (set-mark (point))
    (end-of-line)
    (comment-or-uncomment-region (region-beginning) (region-end)))))
(global-set-key (kbd "C-;") 'one-line-comment)


;; scroll
(setq scroll-preserve-screen-position 'always)
;;(setq mouse-wheel-scroll-amount '(1 ((shift) . 2) ((control)))
;; マウスホイールによるスクロール時の行数
;;   Shift 少なめ、 Ctrl 多めに移動
(setq mouse-wheel-scroll-amount
      '(1                              ; 通常
        ((shift) . 5)                   ; Shift
        ((control) . 40)                ; Ctrl
        ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; golden ratio
;;
;; (golden-ratio-mode 1)
;; (add-to-list 'golden-ratio-exclude-buffer-names " *NeoTree*")


;; 
;; undo-tree
;;
;; undo-tree を読み込む
(require 'undo-tree)
;; undo-tree を起動時に有効にする
(global-undo-tree-mode t)
;; M-/ をredo に設定する。
(global-set-key (kbd "M-/") 'undo-tree-redo)


;;
;; Auto Complete
;;
;; auto-complete-config の設定ファイルを読み込む。
(require 'auto-complete-config)
;(global-auto-complete-mode 0.5)
(global-auto-complete-mode t)
;; よくわからない
;;(ac-config-default)
;; TABキーで自動補完を有効にする
;;(ac-set-trigger-key "TAB")
;; auto-complete-mode を起動時に有効にする
;;(global-auto-complete-mode t)


;;
;;python
;;

;; python-mode
(require 'python-mode)
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)
 
(add-hook 'python-mode-hook
          (function (lambda ()
                      (setq py-indent-offset 4)
                      (setq indent-tabs-mode nil)
                      (flymake-python-load))))


(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


(flymake-mode t)
;;errorやwarningを表示する
(require 'flymake-python-pyflakes)
(flymake-python-pyflakes-load)


;;autoformat
;(require 'py-autopep8)
;(setq py-autopep8-options '("--max-line-length=200")) 
;(setq flycheck-flake8-maximum-line-length 200)
;(define-key python-mode-map (kbd "C-c f") 'py-autopep8)          ; バッファ全体のコード整形
;(define-key python-mode-map (kbd "C-c F") 'py-autopep8-region)   ; 選択リジョン内のコード整形
;(py-autopep8-enable-on-save)

;;yapf auto format
(add-hook 'python-mode-hook 'py-yapf-enable-on-save)


;;
;; anything
;;
;; (require 'anything-startup)

;; (setq anything-c-filelist-file-name "~/.emacs.d/all.filelist")
;; (setq anything-grep-candidates-fast-directory-regexp "^~/.emacs.d/")

;; ;;anythingでファイルリストを検索
;; (define-key global-map (kbd "C-:") 'anything-filelist+)
;; ;;クリップボードの履歴をanythingで検索
;; (global-set-key "\M-y" 'anything-show-kill-ring)
;; (global-set-key (kbd "C-.") 'anything-do-grep)


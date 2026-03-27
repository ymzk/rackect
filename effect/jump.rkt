
(define-effect jump-make-label (v))
(define-effect jump-goto (l v~))

(struct label (k))

(define-handler jump-handler
  [(effect (jump-make-label v) k)
    (let loop ([v~ v])
      (continue k (cons (label loop) v~)))]
  [(effect (jump-goto l v~) k)
    ((label-k l) v~)])

(define-syntax-rule (run-jump body ...)
  (with-effect-handler jump-handler body ...))

(define (make-label v) (perform (jump-make-label v)))
(define (goto l v~) (perform (jump-goto l v~)))

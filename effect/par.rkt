
(define-effect par-cancel ())
(define-effect par-choose (options))

(define-handler par-handler
  [(return x) (list x)]
  [(effect (par-cancel) k) null]
  [(effect (par-choose options) k)
    (append-map (lambda (x) (continue k x)) options)])

(define-syntax-rule (run-par body ...)
  (with-effect-handler par-handler body ...))

(define (cancel)
  (perform (par-cancel)))

(define (choose-from options)
  (perform (par-choose options)))

(define (choose . options)
  (choose-from options))

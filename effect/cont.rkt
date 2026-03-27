
(define-effect cont-callcc (callback))
(define-effect cont-internal-exit (value))

(define-handler cont-handler
  [(effect (cont-callcc callback) k)
    (define (k~ x)
      (let ([ret (continue k x)])
        (perform (cont-internal-exit ret))))
    (continue k (callback k~))]
  [(effect (cont-internal-exit ret) k)
    ret])

(define-syntax-rule (run-cont body ...)
  (with-effect-handler cont-handler body ...))

(define (callcc-f callback)
  (perform (cont-callcc callback)))

(define-syntax-rule (callcc k body ...)
  (callcc-f (lambda (k) body ...)))
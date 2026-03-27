
(define-effect gen-yield (x))

(define-handler gen-handler
  [(return x) empty-stream]
  [(effect (gen-yield x) k) (stream-cons #:eager x (continue k null))])

(define-syntax-rule (run-gen body ...)
  (with-effect-handler gen-handler body ...))

(define (yield x)
  (perform (gen-yield x)))

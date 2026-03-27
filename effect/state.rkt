
(define-effect state-get ())
(define-effect state-put (new-s))

(define-handler state-handler
  [(return x) (lambda (_) x)]
  [(effect (state-get) k) (lambda (s) ((continue k s) s))]
  [(effect (state-put new-s) k) (lambda (old-s) ((continue k null) new-s))])

(define-syntax-rule (run-state init body ...)
  (let ([init-s init])
    ((with-effect-handler state-handler body ...) init-s)))

(define (get) (perform (state-get)))
(define (put new-s) (perform (state-put new-s)))

(define-syntax-rule (modify x body ...)
  (modify-impl (lambda (x) body ...)))

(define (modify-impl f)
  (put (f (get))))

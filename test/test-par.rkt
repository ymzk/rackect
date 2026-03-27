
(load "effect/par.rkt")
(define (main-1)
  (run-par (map (lambda (_) (choose 1 2 3)) (stream->list (in-range 3)))))

(define (main)
  (main-1))

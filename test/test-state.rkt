
(load "effect/state.rkt")

(define (main-1)
  (run-state 10
    (for ([i (list 1 2 3 4)])
      (modify x (* x 2)))
    (get)))

(define (main)
  (main-1))

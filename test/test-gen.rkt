
(load "effect/gen.rkt")

(define (main-1)
  (displayln (stream->list (run-gen
    (yield 1)
    (yield 2)
    (yield 3)
    (yield 4)
    (yield 5)))))

(define (main)
  (main-1))

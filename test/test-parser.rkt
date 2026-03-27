
(load "effect/parser.rkt")

(define (main)
  (main-1))

(define (main-1)
  (displayln
    (run-parser "111222333"
      (many (alt (read-char #\1) (read-char #\2))))))

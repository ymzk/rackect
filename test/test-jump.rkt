
(load "effect/jump.rkt")

(define (main)
  (main-1))

(define (main-1)
  (run-jump
    (match-let ([(cons loop i) (make-label 10)])
      (printf "~A~%" i)
      (if (> i 0) (goto loop (- i 1)) (void))
      (printf "done~%"))))

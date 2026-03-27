
(load "effect/cont.rkt")

(define (main)
  (main-1))

(define (main-1)
  (run-cont
    (printf "final result: ~A~%"
      (callcc exit
        (for ([i (in-naturals)])
          (printf "candidate: ~A~%" i)
          (if (> i 10) (exit i) (void)))))))

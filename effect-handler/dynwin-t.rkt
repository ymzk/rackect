
#lang racket

(require (rename-in "dynwin.rkt" [with-effect-handler with-effect-handler-orig]))



(define-syntax-rule (with-effect-handler H body ...)
  (let ([h H])
    (with-effect-handler-orig h
      (with-effect-handler-orig
        (handler
          [(on-enter) (on-enter-hook h)]
          [(on-exit) (on-exit-hook h)])
        body ...))))

(define nest-level 0)

(define (on-enter-hook h)
  (for ([i (in-range nest-level)])
    (printf "| "))
  (printf "[enter] ~S (~A)~%" (handler-name h) nest-level)
  (set! nest-level (+ nest-level 1)))

(define (on-exit-hook h)
  (set! nest-level (- nest-level 1))
  (for ([i (in-range nest-level)])
    (printf "| "))
  (printf "[exit] ~S (~A)~%" (handler-name h) nest-level))



(provide
  define-effect
  with-effect-handler
  handler
  perform
  continue
  define-handler
  handler-name
  return
  effect
  on-enter
  on-exit
  nest-level)

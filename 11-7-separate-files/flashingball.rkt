#lang racket

(require 2htdp/image)
(require "interfaces.rkt")
(require "ball.rkt")

(provide FlashingBall%)

;; FlashingBall% is like a Ball%, but it displays differently: it
;; changes color on every fourth tick.

(define FlashingBall%
  (class* Ball% (SWidgetListener<%>)

    ;; here are fields of the superclass that we need.
    ;; we should copy the interpretations here so we'll know what they mean.
    (inherit-field radius x y selected?)   

    ; how much time between color changes?
    (field [color-change-interval 4])   
    ; time left til next color change
    (field [time-left color-change-interval])  
    ; the list of possible colors, first elt is current color
    (field [colors (list "red" "green")])  

    ;; the value for init-field w is sent to the superclass.
    (super-new)

    ;; FlashingBall% behaves just like Ball%, except for add-to-scene.
    ;; so we'll find on-tick, on-key, on-mouse methods in Ball%

    ;; Scene -> Scene
    ;; RETURNS: a scene like the given one, but with the flashing ball
    ;; painted on it.
    ;; EFFECT: decrements time-left and changes colors if necessary
    (define/override (add-to-scene s)
      (begin
        ;; is it time to change colors?
        (if (zero? time-left)
          (change-colors)
          (set! time-left (- time-left 1)))
        ;; call the super.  The super calls (get-image) to find the
        ;; image. 
        (super add-to-scene s)))

    ;; RETURNS: the image of this widget.
    ;; NOTE: this is dynamic-- it depends on color
    (define/override (get-image)
      (circle radius
        (if selected? "solid" "outline")
        (first colors)))

    ;; -> Void
    ;; EFFECT: rotate the list of colors, and reset time-left
    (define (change-colors)
      (set! colors (append (rest colors) (list (first colors))))
      (set! time-left color-change-interval))
    
    ))

;; rules

;; The object is to get as close as you can to 11 points without going over, and be closer to 11 than the dealer.

;; Aces are worth 1 or 6 points. Kings are worth 5. Two-card combinations that equal 11 are called 11!s, and pay at a higher rate.

;; The dealer must hit on 8 or less and stand on 9 or above.

;; The payouts are:

;; 5:1 for 11!, 2:1 for winning, and 1:1 for tying with the dealer. Ties are known as "pushes."


(def hand cards
  (= cards (sort (compare > (fn (card) (if (is card 'a) 6
			    (is card 'k) 5
			    card)))
		 cards))
  (if (no cards)
      0
      (is (car cards) 'a)
      (let count (+ 6
		    (apply hand (cdr cards)))
	   (if (> count 11)
	       (- count 5)
	       count))
      (+ (val (car cards))
	 (apply hand (cdr cards)))))

(def low-hand cards
  (if (no cards)
      0
      (+ (val (car cards) 't)
	 (apply low-hand (cdr cards)))))


(def val (card (o safe-aces nil))
     (if (is card 'k)
	 5
       (number card)
       card
       safe-aces
       1
       6))

(def stock-deck ()
  (obj a 4
       2 4
       3 4
       4 4
       5 4
       k 4))

(def survival-chance (opponent . yours)
  (with (score (apply hand yours)
	 deck (apply get-left (cons opponent yours))
	 safe 0
	 total (- 24 (len (cons opponent yours))))
	(each (card count) deck
	      (when (<= (+ score (val card 't))
			11)
		(++ safe count)))
	(prn (num (/ safe total) 4 't 't) "% chance of survival")
(/ safe total)))

(def get-left cards
  (if (no cards)
      (stock-deck)
      (let deck (apply get-left (cdr cards))
	   (-- (deck (car cards)))
	   deck)))
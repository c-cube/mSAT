
; nested ifs
(declare-sort u 0)
(declare-fun a () u)
(declare-fun b () u)
(declare-fun c () u)
(declare-fun d () u)
(declare-fun q0 () Bool)
(declare-fun q1 () Bool)
(declare-fun q2 () Bool)
(declare-fun p (u) Bool)
(assert (p a))
(assert (p b))
(assert (p c))
(assert (p d))
(assert (not (p (ite q0 (ite q1 a b) (ite q2 c d)))))
(check-sat)
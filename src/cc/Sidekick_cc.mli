(** {2 Congruence Closure} *)

open Sidekick_core
module type S = Sidekick_core.CC_S

module Make (A: CC_ARG)
  : S with module T = A.T 
       and module Lit = A.Lit
       and module P = A.P
       and module Actions = A.Actions

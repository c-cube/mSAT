(*
MSAT is free software, using the Apache license, see file LICENSE
Copyright 2015 Guillaume Bury
*)

module type S = Backend_intf.S

module type Arg = sig

  type proof
  type lemma
  type formula

  val print : Format.formatter -> formula -> unit
  val prove : Format.formatter -> lemma -> unit
  val context : Format.formatter -> proof -> unit
end

module Make(S : Res.S)(A : Arg with type formula := S.formula
                                and type lemma := S.lemma
                                and type proof := S.proof) = struct

  let pp_nl fmt = Format.fprintf fmt "@\n"
  let fprintf fmt format = Format.kfprintf pp_nl fmt format

  let _clause_name = S.Clause.name

  let _pp_clause fmt c =
    let rec aux fmt = function
      | [] -> ()
      | a :: r ->
        let f, pos =
          if S.Atom.is_pos a then
            S.Atom.lit a, true
          else
            S.Atom.lit (S.Atom.neg a), false
        in
        fprintf fmt "%s _b %a ->@ %a"
          (if pos then "_pos" else "_neg") A.print f aux r
    in
    fprintf fmt "_b : Prop ->@ %a ->@ _proof _b" aux (S.Clause.atoms_l c)

  let context fmt p =
    fprintf fmt "(; Embedding ;)";
    fprintf fmt "Prop : Type.";
    fprintf fmt "_proof : Prop -> Type.";
    fprintf fmt "(; Notations for clauses ;)";
    fprintf fmt "_pos : Prop -> Prop -> Type.";
    fprintf fmt "_neg : Prop -> Prop -> Type.";
    fprintf fmt "[b: Prop, p: Prop] _pos b p --> _proof p -> _proof b.";
    fprintf fmt "[b: Prop, p: Prop] _neg b p --> _pos b p -> _proof b.";
    A.context fmt p

  let print fmt p =
    fprintf fmt "#NAME Proof.";
    fprintf fmt "(; Dedukti file automatically generated by mSAT ;)";
    context fmt p;
    ()

end

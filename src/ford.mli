open Graph

(* Un chemin est une liste d'arc, un arc c'est (from * dest * lbl) *)
type 'a path = (Graph.id * Graph.id * 'a) list

(* Cherche un chemin de source vers sink *)
val dfs: ('a * 'a) graph -> Graph.id -> Graph.id -> ('a * 'a) path option

(* Afficher un chemin *)
val print_path: (('a * 'a) -> unit) -> ('a * 'a) path option -> unit

(*val fulkerson: int graph -> int from -> int dest -> int*)

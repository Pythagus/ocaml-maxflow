open Graph

(* Un chemin est une liste d'arc, un arc c'est (from * dest * lbl) *)
type 'a path = (Graph.id * Graph.id * 'a) list

(* Cherche un chemin de source vers sink *)
val dfs: (int * int) graph -> Graph.id -> Graph.id -> (int * ((int * int) path)) option

(* Afficher un chemin *)
val print_path: (('a * 'a) -> unit) -> ('a * 'a) path -> unit

(* Executer l'algorithme de Ford-Fulkerson *)
val fulkerson: int graph -> int -> int -> (int * ((int * int) graph))

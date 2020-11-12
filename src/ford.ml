open Graph

type 'b path = (Graph.id * Graph.id * 'b) list

(* Afficher un chemin *)
 let rec print_path print_label = function
      | None -> Printf.printf "No path found\n%!"
      | Some [] -> ()
      | Some ((from, dest, lbl) :: tail) ->
        Printf.printf "-> From %d to %d " from dest ;
        print_label lbl ;
        Printf.printf "\n%!" ;
        print_path print_label (Some tail)


(* Executer l'algorithme DFS pour trouver un chemin *)
(* entre source et sink *)
let dfs graph source sink =
    let rec loop current visited_nodes path =
        if current = sink
        then Some path
        else
            let rec inner_loop = function
                | [] -> None
                | (dest, (flow, capacity)) :: tail ->
                    if (flow < capacity)
                    then loop dest (current :: visited_nodes) ((current, dest, (flow, capacity)) :: path)
                    else inner_loop tail
            in inner_loop (Graph.out_arcs graph current)
    in
    loop source [] []



(*
let fulkerson input_graph source sink =
    (* Initialiser les flots *)
    let f g from dest lbl = Graph.new_arc g from dest (0 * lbl) in
    let flow_graph = Graph.e_fold input_graph f Graph.empty_graph in

    (* Tant que l'on trouve un chemin possible *)
        (* Initialiser variable chemin à [] *)
        (* Initialiser variable flot maximum du chemin à +inf *)

        (* Tant que l'on trouve un arc possible chez ses enfants *)
            (* Ajouter l'arc au chemin *)
            (* Modifier le flot max du chemin *)
        (* *)

        (* Modifier les flots des arcs du chemin *)
        (* Modifier le flot maximal du graphe *)
    (* *)

    let rec dfs from used_nodes result =
        if from = sink
        then result
        else
            let voisin = (* trouver voisin non utilisé*) in
            dfs voisin (voisin :: used_nodes) (arc :: result)

(*
    let rec loop_find_arc current used_arcs =
        let iter_f (path * max_flow) from dest (flow * capacity) = 
            if (from = current) && (flow < capacity)
            then 
                (* Faire attention aux boucles *)
                let new_max_flow = min max_flow (capacity - flow) in
                let new_path = ((from * dest * (flow * capacity)) :: path) in
                
                if (dest = sink)
                then (new_path * new_max_flow)
                else
                    let (new_path * new_max_flow) = loop_find_arc dest in
                    let final_path = estrser in
                    let final_max_flow = min max_flow new_max_flow in
                    (final_path * final_max_flow)
            else if (dest = current) && (flow > 0)
            then 
                (* Faire attention aux boucles *)
                let new_max_flow = min max_flow flow in
                let new_path = ((from * dest * (flow * capacity)) :: path) in
                if (from = sink) (* Peut-être inutile *)
                then (new_path * new_max_flow)
                else loop_find_arc from ;
        Graph.e_fold flow_graph iter_f ([] * (int_of_float infinity));
    in
        let (path * max_flow) = loop_find_arc source in
    

    loop from
    ()
*)*)
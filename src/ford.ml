open Graph

exception Ford_error of string

type 'b path = (Graph.id * Graph.id * 'b) list

(* Afficher un chemin *)
 let rec print_path print_label = function
      | [] -> ()
      | ((from, dest, lbl) :: tail) ->
        Printf.printf "-> From %d to %d " from dest ;
        print_label lbl ;
        Printf.printf "\n%!" ;
        print_path print_label tail


(* Executer l'algorithme DFS pour trouver un chemin
    entre source et sink *)
let dfs graph source sink =
    let rec loop current visited_nodes path max_flow =
        if current = sink
        then 
            match max_flow with
                | None -> raise (Ford_error "Ford.DFS : path with infinite flow")
                | Some flow -> Some (flow, List.rev path)
        else
            let rec inner_loop = function
                | [] -> None
                | (from, dest, (flow, capacity)) :: tail ->
                    let node_already_visited reached_node = List.exists (fun node -> node = reached_node) visited_nodes in

                    (* Faire le prochain appel de DFS et tester le résultat *)
                    let inner_loop_iter node_from arc_flow = 
                        (* Trouver le flot minimum entre le flot déjà
                            enregistré (loop : max_flow) et le flow de
                            l'arc courant. *)
                        let new_max_flow = match max_flow with
                            | None -> Some arc_flow
                            | Some flow -> Some (min flow arc_flow) in 

                        (* Prochaine itération de DFS *)
                        let next_iter = loop node_from (current :: visited_nodes) ((from, dest, (flow, capacity)) :: path) new_max_flow in
                        match next_iter with
                            | None -> inner_loop tail
                            | Some x -> Some x
                    in

                    (* Si c'est un arc dans le bon sens avec du flot de disponible *)
                    if (from = current) && (flow < capacity) && not(node_already_visited dest)
                    then inner_loop_iter dest (capacity - flow)
                    (* Si c'est un arc à l'envers qui a déjà du flot (au moins 1) *)
                    else if (dest = current) && (flow > 0) && not(node_already_visited from)
                    then inner_loop_iter from flow
                    else inner_loop tail
            in
                inner_loop (Graph.inout_arcs graph current)
    in loop source [] [] None


let fulkerson input_graph source sink = 
    (* Initialiser les flots *)
    let flow_graph = Tools.gmap input_graph (fun lbl -> (0, lbl)) in

    let rec loop loop_graph max_flow =
        match dfs loop_graph source sink with
            | None -> (max_flow, loop_graph)
            | Some (path_flow, path) ->
                (* We may use fold *)
                let rec inner_loop graph current = function
                    | [] -> loop graph (max_flow + path_flow)
                    | (from, dest, (flow, capacity)) :: rest ->
                        let next_iter flow current = 
                            inner_loop (Graph.new_arc graph from dest (flow, capacity)) current rest 
                        in

                        match current with
                            | x when x = from -> next_iter (flow + path_flow) dest
                            | x when x = dest -> next_iter (flow - path_flow) from
                            | _ -> raise (Ford_error "Ford.Fulkerson : invalid path found")
                in inner_loop loop_graph source path
    in loop flow_graph 0

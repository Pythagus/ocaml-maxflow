open Graph

type 'b path = (Graph.id * Graph.id * 'b) list

(* Afficher un chemin *)
 let rec print_path print_label = function
      | [] -> ()
      | ((from, dest, lbl) :: tail) ->
        Printf.printf "-> From %d to %d " from dest ;
        print_label lbl ;
        Printf.printf "\n%!" ;
        print_path print_label tail


(* Executer l'algorithme DFS pour trouver un chemin *)
(* entre source et sink *)
let dfs graph source sink =
    let rec loop current visited_nodes path max_flow =
        if current = sink
        then 
            match max_flow with
                | None -> failwith "An error occurred!"
                | Some flow -> Some (flow, List.rev path)
        else
            let rec inner_loop = function
                | [] -> None
                | (dest, (flow, capacity)) :: tail ->
                    if (flow < capacity) && not(List.exists (fun node -> node = dest) visited_nodes)
                    then 
                        let next_iter = loop dest (current :: visited_nodes) ((current, dest, (flow, capacity)) :: path) in
                        let arc_flow  = capacity - flow in
                        let new_max_flow = match max_flow with
                            | None -> Some arc_flow
                            | Some flow -> Some (min flow arc_flow) in 

                        match next_iter new_max_flow with
                            | None -> inner_loop tail
                            | Some x -> Some x
                    else inner_loop tail
            in inner_loop (Graph.out_arcs graph current)
    in loop source [] [] None


let fulkerson input_graph source sink = 
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

    (* Initialiser les flots *)
    let flow_graph = Tools.gmap input_graph (fun lbl -> (0, lbl)) in

    let rec loop loop_graph max_flow =
        match dfs loop_graph source sink with
            | None -> (max_flow, loop_graph)
            | Some (path_flow, path) ->
                (* We may use fold *)
                let rec inner_loop graph = function
                    | [] -> loop graph (max_flow + path_flow)
                    | (from, dest, (flow, capacity)) :: rest ->
                        inner_loop (Graph.new_arc graph from dest (flow + path_flow, capacity)) rest
                in inner_loop loop_graph path
    in loop flow_graph 0

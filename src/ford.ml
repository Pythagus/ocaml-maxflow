open Graph

let fulkerson graph from dest =
    (* Initialiser les flots *)
    let f g from dest lbl = Graph.new_arc g from dest (0 * lbl) in
    let g = Graph.e_fold graph f Graph.empty_graph in

    (* Tant que l'on trouve un chemin possible *)
        (* Initialiser variable chemin à NULL *)
        (* Initialiser variable flot maximum du chemin à 0 *)

        (* Tant que l'on trouve un arc possible chez ses enfants *)
            (* Ajouter l'arc au chemin *)
            (* Modifier le flot max du chemin *)
        (* *)

        (* Modifier les flots des arcs du chemin *)
        (* Modifier le flot maximal du graphe *)
    (* *)

    let rec loop_find_arc current path =
        let iter_f from dest (flow * capacity) = 
            if (from = current) && (flow < capacity)
            then 
                (* Faire attention aux boucles *)
                loop_find_arc dest ((from * dest * (flow * capacity)) :: path) ;
            else
                if (dest = current) && (flow > 0)
                then 
                    (* Faire attention aux boucles *)
                    loop_find_arc from ((from * dest * (flow * capacity)) :: path) ;

        Graph.e_iter g iter_f ;
    in

    loop from
    ()
   
let () =

  Random.self_init () ;

  let _source = Random.int 6 in

  (* Generate a random sink different than the source *)
  let rec generate_sink = function
    | same when same = _source -> generate_sink (Random.int 6)
    | x -> x
  in
  let _sink = generate_sink (Random.int 6) in

  (* Open file *)
  let graph = Gfile.from_file "graphs/graph1" in

  (* Rewrite the graph that has been read. *)
  let () =
    (* Convertir le string graph en int graph *)
    let int_graph = Tools.gmap graph int_of_string in


    (* Test de Tools.clone_nodes *)
    let cloned_graph = Tools.clone_nodes int_graph in
    let iter graph = fun node ->
      if not(Graph.node_exists graph node)
      then failwith ("Node " ^ (string_of_int node) ^ " doesn't exist")
    in
    Graph.n_iter_sorted cloned_graph (iter int_graph) ;
    Graph.n_iter_sorted int_graph (iter cloned_graph) ;
    Graph.e_iter cloned_graph (fun x y -> failwith "Cloned graph has an arc!") ;
    Printf.printf "Test Tools.cloned_graph passed!\n%!" ;

    (* Test de Tools.gmap *)
    let mapped_graph = Tools.gmap int_graph string_of_int in
    let map_test (graph : string Graph.graph) = Printf.printf "Test Tools.gmap passed!\n%!" in
    map_test mapped_graph ;

    (* Test de Tools.add_arc *)
    let label_added = 5 in
    let graph_with_added_arc = Tools.add_arc int_graph _source _sink label_added in
    let execute_test_add_arc =
    match Graph.find_arc graph_with_added_arc _source _sink with
      | None -> failwith "Arc not added"
      | Some new_lbl -> match Graph.find_arc int_graph _source _sink with
        | None when new_lbl <> label_added -> failwith "Incorrect new label (from None)" ;
        | None when new_lbl = label_added -> Printf.printf "Test Tools.add_arc passed!\n%!" ;
        | Some x when new_lbl <> label_added + x -> Printf.printf "nl = %d ; la = %d ; x = %d\n%!" new_lbl label_added x ;
        failwith "Incorrect new label (from Some)" ;
        | Some x when new_lbl = label_added + x -> Printf.printf "Test Tools.add_arc passed!\n%!" ;
        | _ -> failwith "Test Tools.add_arc: weird case\n%!" ;
    in
    execute_test_add_arc ;

    (* Test de Ford.dfs *)
    let load_int_graph file flow = 
      Tools.gmap (Gfile.from_file ("graphs/" ^ file)) (fun lbl -> (flow, int_of_string lbl)) 
    in

    let test_dfs g source sink expected_path expected_max_flow display =
      match (Ford.dfs g source sink) with
        | None when expected_path = [] -> Printf.printf "Test Ford.dfs (%s) passed!\n%!" display
        | Some (max_flow, path) when path = expected_path && max_flow = expected_max_flow
          -> Printf.printf "Test Ford.dfs (%s) passed!\n%!" display
        | Some _ when expected_path = [] -> failwith ("Ford.dfs: Unexpected path found (" ^ display ^ ")")
        | None when expected_path <> [] -> failwith ("Ford.dfs: Expected path, but none found (" ^ display ^ ")")
        | _ -> failwith ("Ford.dfs: weird case (" ^ display ^ ")")
    in

    (* Test sur graphs/graph3 : impossible (aucun arc) *)
    let flow_graph3 = load_int_graph "graph3" 0 in
    test_dfs flow_graph3 0 1 [] 0 "graph3" ;

    (* Test sur graphs/graph4 : impossible (unique arc plein) *)
    let flow_graph4 = load_int_graph "graph4" 1 in
    test_dfs flow_graph4 0 1 [] 0 "graph4" ;

       (* Test sur graphs/graph5 : possible (unique arc vide) *)
    let flow_graph5 = load_int_graph "graph5" 0 in
    test_dfs flow_graph5 0 1 [(0, 1, (0, 1))] 1 "graph5" ;

    (* Test sur graphs/graph6 : simple (arcs dans le bon sens, arcs vides) *)
    let flow_graph6 = load_int_graph "graph6" 0 in
    test_dfs flow_graph6 0 3 [(0, 1, (0, 1)) ; (1, 2, (0, 1)) ; (2, 3, (0, 1))] 1 "graph6" ;

    (* Test sur graphs/graph7 : moins simple (arc dans le bon sens, arcs vides) *)
    let flow_graph7 = load_int_graph "graph7" 0 in
    test_dfs flow_graph7 0 5 [(0, 2, (0, 1)) ; (2, 3, (0, 1)) ; (3, 5, (0, 1))] 1 "graph7" ;

    (* Test sur graphs/graph8 : possible (arc à l'envers plein) *)
    let flow_graph8 = load_int_graph "graph8" 1 in
    test_dfs flow_graph8 0 1 [(1, 0, (1, 1))] 1 "graph8" ;

    (* Test sur graphs/graph9 : moins simple (arcs à l'envers pleins) *)
    let flow_graph9 = load_int_graph "graph9" 1 in
    test_dfs flow_graph9 0 3 [(1, 0, (1, 1)) ; (2, 1, (1, 1)) ; (3, 2, (1, 1))] 1 "graph9" ;

    (* Test sur graphs/graph10 : moins simple (arcs à l'envers pleins, arcs dans le bon sens vides) *)
    let flow_graph10 = load_int_graph "graph10" 0 in
    let flow_graph10 = Graph.new_arc flow_graph10 4 2 (1, 1) in
    let flow_graph10 = Graph.new_arc flow_graph10 3 2 (2, 2) in
    test_dfs flow_graph10 0 5 [(0, 2, (0, 1)) ; (3, 2, (2, 2)) ; (3, 5, (0, 1))] 1 "graph10" ;

    (* Test sur graphs/graph11 : exemple de graph relativement complexe *)

    (* Open file *)
    let graph11 = Gfile.from_file "graphs/graph11" in
    (* Convertir le string graph en int graph *)
    let int_graph11 = Tools.gmap graph11 int_of_string in
    
    let (max_flow, _) = Ford.fulkerson int_graph11 0 5 in
    if max_flow = 25
    then Printf.printf "Test Ford.fulkerson passed!\n%!"
    else failwith "Ford.fulkerson: wrong max_flow returned" ;

    (*
    (* Execute l'algorithme de Fulkerson *)
    let (max_flow, g) = Ford.fulkerson int_graph _source _sink in

    (* Affichage du résultat *)
    Printf.printf "Flow max : %d\n%!" max_flow ;
    let string_of_label (flow, cap) = (string_of_int flow) ^ " / " ^ (string_of_int cap) in
    Gfile.export outfile (Tools.gmap g string_of_label)
    *)

    (*
    TODO:
    Readme.md :
      - comment on a fait l'algo
      - justifier Graph.inout_arcs
      - lister les tests (avec des jolis graphes)
      - comment tester (on a changé le Makefile)

    Medium project peut-être
    *)
  in ()
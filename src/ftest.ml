open Gfile
open Tools
open Ford
    
let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  
  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in

  (* Open file *)
  let graph = from_file infile in

  (* Rewrite the graph that has been read. *)
  let () =
    (* Convertir le string graph en int grapĥ *)
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
    match Graph.find_arc graph_with_added_arc _source _sink with
      | None -> failwith "Arc not added"
      | Some new_lbl -> match Graph.find_arc int_graph _source _sink with
        | None -> if new_lbl <> label_added 
          then failwith "Incorrect new label (from None)" 
          else Printf.printf "Test Tools.add_arc passed!\n%!" ;
        | Some x -> if new_lbl + label_added <> x 
          then failwith "Incorrect new label (from Some)"
          else Printf.printf "Test Tools.add_arc passed!\n%!" ;

    (* Test de Ford.dfs *)
    let load_int_graph file flow = 
      Tools.gmap (from_file ("graphs/" ^ file)) (fun lbl -> (flow, int_of_string lbl)) 
    in

    (* Test sur graphs/graph3 : impossible (aucun arc) *)
    let flow_graph3 = load_int_graph "graph3" 0 in

    (* Test sur graphs/graph4 : impossible (unique arc plein) *)
    let flow_graph4 = load_int_graph "graph4" 1 in

       (* Test sur graphs/graph5 : possible (unique arc vide) *)
    let flow_graph5 = load_int_graph "graph5" 0 in

    (* Test sur graphs/graph6 : simple (arcs dans le bon sens, arcs vides) *)
    let flow_graph6 = load_int_graph "graph6" 0 in

    (* Test sur graphs/graph7 : moins simple (arc dans le bon sens, arcs vides) *)
    let flow_graph7 = load_int_graph "graph7" 0 in

    (* Test sur graphs/graph8 : possible (arc à l'envers plein) *)
    let flow_graph8 = load_int_graph "graph8" 1 in

    (* Test sur graphs/graph9 : moins simple (arcs à l'envers pleins) *)
    let flow_graph9 = load_int_graph "graph9" 1 in

    (* Test sur graphs/graph10 : moins simple (arcs à l'envers pleins, arcs dans le bon sens vides) *)
    let flow_graph10 = load_int_graph "graph10" 0 in
    (* //TODO : remplir arcs 2 <- 4 et 2 <- 3 *)





    (* Execute l'algorithme de Fulkerson *)
    let (max_flow, g) = Ford.fulkerson int_graph _source _sink in

    (* Affichage du résultat *)
    Printf.printf "Flow max : %d\n%!" max_flow ;
    let string_of_label (flow, cap) = (string_of_int flow) ^ " / " ^ (string_of_int cap) in
    export outfile (Tools.gmap g string_of_label)
  in ()
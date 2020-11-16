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
    (*
    let print_arc (from, dest, lbl) =
      Printf.printf "%d -> %d (%s)\n%!" from dest lbl
    in
    let arcs = Graph.inout_arcs graph _source in
    List.iter print_arc arcs;
    *)
    let print_lbl (flow, cap) = Printf.printf "(%d / %d)" flow cap in

    let int_graph = Tools.gmap graph int_of_string in
    (*
    let flow_graph = Tools.gmap int_graph (fun lbl -> (lbl, lbl)) in

    let result = Ford.dfs flow_graph _source _sink in
    match result with
      | None -> Printf.printf "Pas de chemin trouvé"
      | Some (flow, path) -> Printf.printf "Chemin de flot %d :\n%!" flow;
        Ford.print_path print_lbl path;
    *)
    
    let (max_flow, g) = Ford.fulkerson int_graph _source _sink in
    Printf.printf "Flow max : %d\n%!" max_flow ;

    let string_of_label (flow, cap) = (string_of_int flow) ^ " / " ^ (string_of_int cap) in
    export outfile (Tools.gmap g string_of_label)
    
  in ()
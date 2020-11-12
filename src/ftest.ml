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
    let rec print_path = function
      | None -> Printf.printf "Aucun chemin trouvé\n%!"
      | Some [] -> ()
      | Some ((from, dest, (flow, capacity)) :: tail) ->
        Printf.printf "De %d vers %d (%d / %d)\n%!" from dest flow capacity;
        print_path (Some tail)
    in
    
    let int_graph = Tools.gmap graph int_of_string in
    let flow_graph = Tools.gmap int_graph (fun lbl -> (0, lbl)) in

    print_path (Ford.dfs flow_graph _source _sink) in
    ()
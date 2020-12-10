
type name = string

type are_spaces_better = bool
type spaces_preferece = are_spaces_better option

type are_inline_braces_better = bool
type braces_preference = are_inline_braces_better option

type is_emacs_better = bool
type editor_preference = is_emacs_better option
    
type nb_of_beds = int
  
type person = Hacker of name * are_spaces_better * are_inline_braces_better * is_emacs_better
            | Student of name * nb_of_beds * spaces_preferece * braces_preference * editor_preference 

type id = int
  
type id_person = id * person

(* Reads a line with a hacker. *)
let read_hacker id hlist line =
  let test_input name sp br ed =
    let error_message = "read_hacker (" ^ name ^ ")" in
    let spaces = if sp = "spaces" then true else if sp = "tabs" then false else failwith error_message in
    let braces = if br = "inline" then true else if br = "newline" then false else failwith error_message in
    let editor = if ed = "emacs" then true else if ed = "vim" then false else failwith error_message in
    (id, Hacker (name, spaces, braces, editor)) :: hlist
  in
  try Scanf.sscanf line "Hacker %s %s %s %s" test_input
  with e ->
    Printf.printf "Cannot read hacker in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a line with a student. *)
let read_student id slist line =
  let test_input name beds sp br ed =
    let error_message = "read_student (" ^ name ^ ")" in
    let spaces = if sp = "whatever" then None
                 else if sp = "spaces" then Some true else if sp = "tabs" then Some false else failwith "spaces" in
    let braces = if br = "whatever" then None
                 else if br = "inline" then Some true else if br = "newline" then Some false else (Printf.printf "%s/%s/%s\n%!" sp br ed; failwith "braces") in
    let editor = if ed = "whatever" then None
                 else if ed = "emacs" then Some true else if ed = "vim" then Some false else failwith "editor" in
    (id, Student (name, beds, spaces, braces, editor)) :: slist
  in
  try Scanf.sscanf line "Student %s %d %s %s %s" test_input
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"
                 
let from_file path =

  let infile = open_in path in

  (* Read all lines until end of file. 
   * n is the current node counter. *)
  let rec input_loop n (hlist, slist) =
    try
      let line = input_line infile in

      (* Remove leading and trailing spaces. *)
      let line = String.trim line in

      (* Ignore empty lines *)
      if line = "" then input_loop n (hlist, slist)

      (* The first character of a line determines its content : n or e. *)
      else match line.[0] with
        | 'H' -> input_loop (n+1) ((read_hacker n hlist line), slist)
        | 'S' -> input_loop (n+1) (hlist, (read_student n slist line))

        (* It should be a comment. *)
        | _ -> input_loop n (hlist, slist)

    with End_of_file -> (hlist, slist) (* Done *)
  in

  let graph = Graph.empty_graph in
  let source = 0 in
  let sink = 1 in
  let graph = Graph.new_node graph source in (* Source *)
  let graph = Graph.new_node graph sink in (* Sink *)

  let (hlist, slist) = input_loop 2 ([], []) in

  let add_hacker g (id, hack) =
    let g = Graph.new_node g id in
    Graph.new_arc g source id 1
  in

  let graph = List.fold_left add_hacker graph hlist in

  let add_student g (id, stud) =
    let g = Graph.new_node g id in
    let Student (_, beds, _, _, _) = stud in
    Graph.new_arc g id sink beds
  in

  let graph = List.fold_left add_student graph slist in

  let are_compatible hack stud =
    let helper h_elt s_opt =
      match s_opt with
        | None -> true
        | Some s_elt -> h_elt = s_elt
    in 
    let Hacker (_, h_sp, h_br, h_ed) = hack in
    let Student (_, _, s_sp, s_br, s_ed) = stud in
    (helper h_sp s_sp) && (helper h_br s_br) && (helper h_ed s_ed)
  in

  let rec inner_loop g idhack = function
    | [] -> g
    | idstud :: studs ->
      let (hid, hack) = idhack in
      let (sid, stud) = idstud in
      let new_g = if are_compatible hack stud then (Graph.new_arc g hid sid 1) else g in
      inner_loop new_g idhack studs
  in

  let rec loop g studs = function
    | [] -> g
    | idhack :: hacks ->
      let new_g = inner_loop g idhack studs in
      loop new_g studs hacks
  in

  let final_graph = loop graph slist hlist in
  
  close_in infile ;
  final_graph

let input_graph = from_file "convention.txt"
let flow_graph = Tools.gmap input_graph (fun lbl -> (0, lbl))
let string_of_label (flow, cap) = (string_of_int flow) ^ " / " ^ (string_of_int cap);;
Gfile.export "outfile" (Tools.gmap flow_graph string_of_label)
open Graph

let clone_nodes gr =
  let func current id = Graph.new_node current id in
  Graph.n_fold gr func (Graph.empty_graph)


let gmap gr f =
  let func current from dest lbl =
    Graph.new_arc current from dest (f lbl) in
  Graph.e_fold gr func (clone_nodes gr)

let add_arc gr from dest n =
  match (Graph.find_arc gr from dest) with
    | Some lbl -> Graph.new_arc gr from dest (lbl + n)
    | None -> Graph.new_arc gr from dest n
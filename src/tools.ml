open Graph

let clone_nodes gr =
  let func current id = Graph.new_node current id in
  Graph.n_fold gr func (Graph.empty_graph)


let gmap gr f =
  let func current from dest lbl =
    let new_lbl = f lbl in
    Graph.new_arc current from dest new_lbl in
  Graph.e_fold gr func (clone_nodes gr)

let add_arc gr from dest value = Graph.empty_graph 
open Graph

let clone_nodes gr =
  let func current id = Graph.new_node current id in
  Graph.n_fold gr func (Graph.empty_graph)


let gmap gr f = assert false

let add_arc gr from vers value = Graph.empty_graph 
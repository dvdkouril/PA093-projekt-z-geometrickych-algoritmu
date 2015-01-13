class Edge{
  Vertex v1;
  Vertex v2;
  
  Edge(Vertex from, Vertex to) {
    v1 = from;
    v2 = to;
  }
  
  String toString() {
    return v1 + " -> " + v2;
  }
}

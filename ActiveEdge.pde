class ActiveEdge {
  Vertex from;
  Vertex to;
  ActiveEdge edgeNext;
  ActiveEdge nextTriangleEdge;
  //bool visited; ???????
  
  ActiveEdge(Vertex from, Vertex to, ActiveEdge nextE, ActiveEdge nextTriangleE) {
    this.from = from;
    this.to = to;
    edgeNext = nextE;
    nextTriangleEdge = nextTriangleE;
  }
  
  ActiveEdge(ActiveEdge e) {
    this.from = e.from;
    this.to = e.to;    
  }
  
  void flipDirection() {
    Vertex temp = from;
    from = to;
    to = temp;
  }
  
  String toString() {
    return from + " -> " + to;
  }
  
  public boolean equals(Object obj) {
    if (!(obj instanceof ActiveEdge)) {
      return false;
    } else {
      ActiveEdge e = (ActiveEdge) obj;
      if ( this.from.equals(e.from) && this.to.equals(e.to) ) {
        return true;
      } else {
        return false;
      }
    }
  }
}

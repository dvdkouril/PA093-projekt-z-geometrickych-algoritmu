class KdNode {
  int depth;
  Vertex nodePoint;
  KdNode parent;
  KdNode lesser;
  KdNode greater;
  
  KdNode() {
    depth = 0;
    nodePoint = null;
    parent = null;
    lesser = null;
    greater = null;
  }
}

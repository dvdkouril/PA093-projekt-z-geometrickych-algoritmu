float crossproduct(Vertex p1, Vertex p2, Vertex p3) {
  float u1 = p2.x - p1.x;
  float v1 = p2.y - p1.y;
  float u2 = p3.x - p1.x;
  float v2 = p3.y - p1.y;
  return u1 * v2 - v1 * u2;
}

Circle circumCircle(Vertex p1, Vertex p2, Vertex p3) {
  float cp = crossproduct(p1, p2, p3);
  if ( cp != 0 ) {
    float p1Sq = p1.x*p1.x + p1.y*p1.y;
    float p2Sq = p2.x*p2.x + p2.y*p2.y;
    float p3Sq = p3.x*p3.x + p3.y*p3.y;
    
    float num = p1Sq*(p2.y - p3.y) + p2Sq*(p3.y - p1.y) + p3Sq*(p1.y - p2.y);
    float cx = num / (2.0 * cp);
    num = p1Sq*(p3.x - p2.x) + p2Sq*(p1.x - p3.x) + p3Sq*(p2.x - p1.x);
    float cy = num / (2.0 * cp);
    Vertex centre = new Vertex(cx, cy);
    float r = centre.distance(p1);
    //return r;
    Circle c = new Circle(centre, r);
    return c;
  } else return null;
}

float delaunayDistance(ActiveEdge e, Vertex p) {
  Circle circum = circumCircle(e.from, e.to, p);
  testedCircles.add(circum);
  
  Vertex p1 = e.from;
  Vertex p2 = e.to;
  Vertex s = circum.centre;
  
  float scalarProduct1 = (p.x - p1.x)*(p1.y - p2.y) + (p.y - p1.y)*(p2.x - p1.x);
  float scalarProduct2 = (s.x - p1.x)*(p1.y - p2.y) + (s.y - p1.y)*(p2.x - p1.x);
  if (signum(scalarProduct1) == signum(scalarProduct2)) { // in the same halfplane
    return circum.radius;
  } else { // in different halfplanes
    return -1*circum.radius;
  }
}

void delaunayTriangulation(ArrayList<Vertex> list) {
  // random starting point chosen from set of points
  int startIndex = (int)random(1, list.size()-1); // fake
  Vertex start = list.get(startIndex);
  
  // finding closest point to the first randomly chosen one
  int minIndex = 0;
  Vertex minVertex = list.get(0);
  float minDistance = start.distance(minVertex);
  for (int i = 0; i < list.size(); i++) {
    if (i != startIndex) {
      float dist = start.distance(list.get(i));
      if (dist < minDistance) {
        minDistance = dist;
        minVertex = list.get(i);
        minIndex = i;
      }
    }
  }
  
  ActiveEdge eFirst = new ActiveEdge(start, minVertex, null, null);
  
  Vertex p = getMinDelaunayDistVertex(list, eFirst);
  if (p == null) {
    eFirst.flipDirection();
  }
  p = getMinDelaunayDistVertex(list, eFirst);
  
  ActiveEdge e2First = new ActiveEdge(eFirst.to, p, null, null);
  ActiveEdge e3First = new ActiveEdge(p, eFirst.from, null, null);
  
  LinkedList<ActiveEdge> queue = new LinkedList<ActiveEdge>(); // add je enqueue, poll je dequeue
  queue.add(eFirst);
  queue.add(e2First);
  queue.add(e3First); 
  
  //list.remove(eFirst.from);
  //list.remove(eFirst.to);
 
  int counter = 0;
  while (queue.size() > 0) {
  //while ((queue.size() > 0) && (counter < 100)) {
    println("queue: " + queue);
    ActiveEdge e = queue.poll();
    //print("e = " + e);
    e.flipDirection();
    //println("; flipped e = " + e);
    //list.remove(e.from);
    //list.remove(e.to);
    Vertex pMinLeft = getMinDelaunayDistVertex(list, e);
    println("edge = " + e);
    println("p = " + pMinLeft);
    if (pMinLeft != null) {
      ActiveEdge e2 = new ActiveEdge(e.to, pMinLeft, null, null);
      ActiveEdge e3 = new ActiveEdge(pMinLeft, e.from, null, null);
      ActiveEdge e2r = new ActiveEdge(e2);
      e2r.flipDirection();
      ActiveEdge e3r = new ActiveEdge(e3);
      e3r.flipDirection();
      if (!queue.contains(e2) && !queue.contains(e2r) && !finalTriangulation.contains(e2) && !finalTriangulation.contains(e2r) ) { 
        queue.add(e2); 
      }
      if (!queue.contains(e3) && !queue.contains(e3r) && !finalTriangulation.contains(e3) && !finalTriangulation.contains(e3r)) { 
        queue.add(e3); 
      }
      //finalTriangulation.add(e);
    }
    finalTriangulation.add(e);
    counter += 1;
  }
  
}

Vertex getMinDelaunayDistVertex(ArrayList<Vertex> list, ActiveEdge e) {
  
  // sets of points that are to left or right to first active edge
  ArrayList<Vertex> leftFromLine = new ArrayList<Vertex>();
  ArrayList<Vertex> rightFromLine = new ArrayList<Vertex>();
  
  for (int i = 0; i < list.size(); i++) {
    Vertex v = list.get(i);
    Vertex A = e.from;
    Vertex B = e.to;
    float det = (B.x-A.x)*(v.y-A.y) - (B.y-A.y)*(v.x-A.x);
    if (det < 0 ) {
      leftFromLine.add(v);
    } else if (det > 0) {
      rightFromLine.add(v);
    }
  }
  
  if (leftFromLine.isEmpty()) { 
    //println("returning null!!!");
    return null;
  }
  
  // finding point from "left" set that has minimal delaunay distance
  int minDelaunayIndex = 0;
  Vertex minDelaunayVert = leftFromLine.get(minDelaunayIndex);
  float minDelaunayDist = delaunayDistance(e, minDelaunayVert);
  for (int i = 0; i < leftFromLine.size(); i++) {
    Vertex tested = leftFromLine.get(i);
    float dDist = delaunayDistance(e, tested);

    if (dDist < minDelaunayDist) {
      minDelaunayIndex = i;
      minDelaunayVert = tested;
      minDelaunayDist = dDist;
    }
  }
  
  return minDelaunayVert;
  
}

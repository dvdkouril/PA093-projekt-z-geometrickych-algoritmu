import java.util.Stack;
import java.util.HashSet;
import java.util.Map;
import java.util.LinkedList;


ArrayList<Vertex> points;
ArrayList<Vertex> convexHull;
ArrayList<Vertex> unprocessedPoints;
ArrayList<Edge> triangulation;
ArrayList<Vertex> polygon;
ArrayList<Circle> testedCircles; // debug
ArrayList<ActiveEdge> finalTriangulation;
ActiveEdge AELstart;
char nextName;
KdNode root;
int strokeColor;
int BORDER = 50;
int MODE = 0; // 0 - adding points
// 1 - editing points
// 2 - deleting points
// 3 - polygon adding


void setup() {
  size(800, 600);
  background(0,0,0);
  points = new ArrayList<Vertex>();
  convexHull = new ArrayList<Vertex>();
  unprocessedPoints = new ArrayList<Vertex>();
  triangulation = new ArrayList<Edge>();
  polygon = new ArrayList<Vertex>();
  finalTriangulation = new ArrayList<ActiveEdge>();
  nextName = 'A';
  root = null;
  strokeColor = 255;
  AELstart = null;
  testedCircles = new ArrayList<Circle>();
}

void draw() {
  background(0, 0, 0);

  PFont f = createFont("Arial", 14, true);
  textFont(f);
  fill(255);
  //textSize(12);
  textAlign(LEFT);

  String sMode = "";
  color modeColor = #000000;
  switch (MODE) {
  case 0:
    sMode = "adding. click to add points.";
    modeColor = #42EA43;
    break;
  case 1:
    sMode = "editing. drag and drop to move points.";
    modeColor = #FFDF3E;
    break;
  case 2:
    sMode = "deleting. click to delete points.";
    modeColor = #D32B41;
    break;
  case 3:
    sMode = "polygon adding. click to add point to polygon.";
  }
  fill(modeColor);
  rect(width - 20, 10, 10, 10);
  fill(255);

  text("mode: " + sMode, 10, 20);
  text("r - random 10 points. c - clear screen (delete all points). a/e/d/p - change mode. h - compute convex hull.  ", 10, height - 10);

  ellipseMode(RADIUS);
  Vertex rightestP = getRightestPoint(points);
  //int num = 0;
  for (int i = 0; i < points.size (); i++) { // points drawing
    if (points.get(i).modified) {
      points.get(i).x = mouseX;
      points.get(i).y = mouseY;
    }
    if (points.get(i).equals(rightestP)) {
      fill(255, 0, 0);
    } else {
      fill(255, 255, 255);
    }

    points.get(i).drawVertex();
  }

  if (convexHull.size() > 1) {
    for (int i = 0; i < convexHull.size () - 1; i++) { // convex hull drawing
      Vertex A = convexHull.get(i);
      Vertex B = convexHull.get(i + 1);
      stroke(255, 255, 255);
      line(A.x, A.y, B.x, B.y);
      stroke(0, 0, 0);
      //text(i, convexHull.get(i).x - 10, convexHull.get(i).y - 5);
    }
    stroke(255, 255, 255);
    line(convexHull.get(convexHull.size()-1).x, convexHull.get(convexHull.size()-1).y, convexHull.get(0).x, convexHull.get(0).y);
    stroke(0, 0, 0);
  }
  
  // polygon drawing
  if (polygon.size() >= 1) {
    for (int i = 0; i < polygon.size()-1; i++) {
      stroke(255);
      line(polygon.get(i).x, polygon.get(i).y, polygon.get(i+1).x, polygon.get(i+1).y);
      println("drawing");
    }
    line(polygon.get(polygon.size()-1).x, polygon.get(polygon.size()-1).y, polygon.get(0).x, polygon.get(0).y);
  }
  
  // triangulation drawing
  if (triangulation.size() >= 1) {
    stroke(255);
    for (int i = 0; i < triangulation.size(); i++) {
      line(triangulation.get(i).v1.x, triangulation.get(i).v1.y, triangulation.get(i).v2.x, triangulation.get(i).v2.y );
    }
    noStroke();
  }

  // Kd Tree drawing 
  if (root != null) {
    //println("root.nodePoint = " + root.nodePoint);
    //strokeColor = 255;
    stroke(255);
    
    drawTree(root, 0, width, 0, height);

    noStroke();
  }
  
  // delaunay triangulation drawing
  for(ActiveEdge e : finalTriangulation) {
    stroke(255);
    line(e.from.x, e.from.y, e.to.x, e.to.y);
    noStroke();    
  }
  
  // debug drawings
  /*ellipseMode(RADIUS);
  noFill();
  stroke(50, 50, 50);
  for (Circle c : testedCircles) {
    ellipse(c.centre.x, c.centre.y, c.radius, c.radius);
  }*/
  
}

void drawTree(KdNode root, float xMin, float xMax, float yMin, float yMax) {

  if (root == null) return; 
  
  if (root.depth % 2 == 0) { // vertical line
    line(root.nodePoint.x, yMin, root.nodePoint.x, yMax);
  } else { // horizontal line
    line(xMin, root.nodePoint.y, xMax, root.nodePoint.y);
  }
  
  //stroke(strokeColor, strokeColor, strokeColor);
  /*if (root.depth % 2 == 0) {
    if (root.parent == null) {
      line(root.nodePoint.x, 0, root.nodePoint.x, height);
    } else {
      if (root.nodePoint.y > root.parent.nodePoint.y) {
        line(root.nodePoint.x, root.parent.nodePoint.y, root.nodePoint.x, height);
      } else {
        line(root.nodePoint.x, 0, root.nodePoint.x, root.parent.nodePoint.y);
      }
    }
  } else {
    if (root.parent == null) {
      line(0, root.nodePoint.y, width, root.nodePoint.y);
    } else {
      if (root.nodePoint.x > root.parent.nodePoint.x) {
        line(root.parent.nodePoint.x, root.nodePoint.y, width, root.nodePoint.y);
      } else {
        line(0, root.nodePoint.y, root.parent.nodePoint.x, root.nodePoint.y);
      }
    }
  }*/

  if (root.depth % 2 == 0) {
    drawTree(root.lesser, xMin, root.nodePoint.x, yMin, yMax);
    drawTree(root.greater, root.nodePoint.x, xMax, yMin, yMax);
  } else {
    drawTree(root.lesser, xMin, xMax, yMin, root.nodePoint.y);
    drawTree(root.greater, xMin, xMax, root.nodePoint.y, yMax);
  }
}

void keyPressed() {
  switch (key) {
  case 'r':
    for (int i = 0; i < 10; i++) {
      points.add(new Vertex(BORDER + random(width - 2*BORDER), BORDER + random(height - 2*BORDER)));
    }
    break;
  case 'a':
    MODE = 0;  // adding mode
    break;
  case 'c':
    points.clear();
    convexHull.clear();
    break;
  case 'e':
    MODE = 1; // editing mode
    break;
  case 'd':
    MODE = 2; // deleting mode
    break;
  case 'h':
    grahamScan(); // graham scan algorithm
    break;
  case 't':
    finalTriangulation.clear();
    delaunayTriangulation(points);
    /*if (polygon.size() > 0) {
      triangulate(polygon);
    } else if (convexHull.size() > 0) {
      triangulate(convexHull);
    }
    triangulate(points);*/
    break;
  case 'k':
    root = generateKdTree(points, 0);
    strokeColor = 255;
    break;
  case 'p':
    MODE = 3;
    break;
  default:
    break;
  }
}

void mousePressed() {

  if (MODE == 1) {
    for (int i = 0; i < points.size (); i++) {
      float pointX = points.get(i).x;
      float pointY = points.get(i).y;

      if ( (mouseX - pointX)*(mouseX - pointX) + (mouseY - pointY)*(mouseY - pointY) <= 25 ) {
        points.get(i).setModified(true);
      }
    }
  }
}

void mouseReleased() {
  if (MODE == 0) { // adding mode
    points.add(new Vertex(mouseX, mouseY));
  } else if (MODE == 2) {  // deleting mode
    for (int i = 0; i < points.size (); i++) {
      float pointX = points.get(i).x;
      float pointY = points.get(i).y;

      if ( (mouseX - pointX)*(mouseX - pointX) + (mouseY - pointY)*(mouseY - pointY) <= 25 ) {
        points.remove(i);
      }
    }
  } else if (MODE == 1) {  // editing mode
    for (int i = 0; i < points.size (); i++) {
      points.get(i).modified = false;
    }
  } else if (MODE == 3) {
    polygon.add(new Vertex(mouseX, mouseY));
    println("polygon = " + polygon);
  }
}

KdNode generateKdTree(ArrayList<Vertex> list, int depth) {
  if (list.size() < 1) {
    return null;
  }

  int medianIndex = pickMedian(list);
  Vertex medianVert = list.get(medianIndex);

  if (list.size() == 1) {
    KdNode v = new KdNode();
    v.nodePoint = medianVert;
    v.depth = depth;
    return v;
  } else {
    ArrayList<Vertex> list1 = new ArrayList<Vertex>();
    ArrayList<Vertex> list2 = new ArrayList<Vertex>();
    if ((depth % 2) == 0) { // depth even => divide by x coordinate

      for (int i = 0; i < list.size (); i++) {
        if (list.get(i) == medianVert) continue;
        if (list.get(i).x <= medianVert.x) {
          list1.add(list.get(i));
        } else {
          list2.add(list.get(i));
        }
      }
      println("list 1 = " + list1);
      println("list 2 = " + list2);
    } else { // depth odd => divide by y coordinate

        for (int i = 0; i < list.size (); i++) {
        if (list.get(i) == medianVert) continue;
        if (list.get(i).y <= medianVert.y) {
          list1.add(list.get(i));
        } else {
          list2.add(list.get(i));
        }
      }
    }

    KdNode vLeft = generateKdTree(list1, depth + 1);
    KdNode vRight = generateKdTree(list2, depth + 1);
    KdNode v = new KdNode();
    v.nodePoint = medianVert;
    v.depth = depth;
    v.lesser = vLeft;
    v.greater = vRight;
    if (vLeft != null) {
      vLeft.parent = v;
    }
    if ( vRight != null) {
      vRight.parent = v;
    }

    return v;
  }
}

void grahamScan() {
  if (points.size() < 3) {
    return;
  }

  convexHull.clear();

  Vertex P = getRightestPoint(points);
  quicksort_angles(points, 0, points.size()-1, P);

  Stack q = new Stack();
  q.push(P);
  q.push(points.get(1));
  q.push(points.get(2));

  for (int i = 3; i < points.size (); i++) {
    while (orientation (secondFromTop (q), (Vertex)q.peek(), points.get(i)) < 0) {
      q.pop();
    }
    q.push(points.get(i));
  }

  while (!q.empty ()) {
    convexHull.add((Vertex)(q.pop()));
  }
}

float orientation(Vertex x, Vertex y, Vertex z) {
  return (y.x-x.x)*(z.y-x.y) - (y.y-x.y)*(z.x-x.x);
}

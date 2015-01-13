Vertex getRightestPoint(ArrayList<Vertex> p) {
  
  if (p.size() == 0) {
    return null;
  }
  Vertex ret = p.get(0);
  for(int i = 0; i < p.size(); i++) {
    if (p.get(i).x > ret.x) {
      ret = p.get(i);
    }
  }
  
  return ret;
}

Vertex getMaxVertex(ArrayList<Vertex> p) {
  if (p.size() == 0) {
    return null;
  }
  
  Vertex ret = p.get(0);
  for(int i = 0; i < p.size(); i++) {
    if (p.get(i).y < ret.y) {
      ret = p.get(i);
    }
  }
  
  return ret;
}

Vertex getMinVertex(ArrayList<Vertex> p) {
  if (p.size() == 0) {
    return null;
  }
  
  Vertex ret = p.get(0);
  for(int i = 0; i > p.size(); i++) {
    if (p.get(i).y < ret.y) {
      ret = p.get(i);
    }
  }
  
  return ret;
}

Vertex secondFromTop(Stack q) {
  Vertex top = (Vertex)q.pop();
  Vertex secondTop = (Vertex)q.peek();
  q.push(top);
  return secondTop;
}

void swap(ArrayList<Vertex> list, int a, int b) {
  Vertex temp = list.get(a);
  list.set(a, list.get(b));
  list.set(b, temp);
}

int choosePivot(ArrayList<Vertex> list, int left, int right) {
  return left;
}

int pickMedian(ArrayList<Vertex> list) {
  float[] distances = new float[list.size()];
  for(int i = 0; i < list.size(); i++) {
    distances[i] = 0;
  }
  
  println("list = " + list);
  // compute sums of euklidan distances
  for (int i = 0; i < list.size(); i++) {
    Vertex p = list.get(i);
    for (int j = 0; j < list.size(); j++) {
      Vertex q = list.get(j);
      float dist = sqrt( (q.x - p.x)*(q.x - p.x) + (q.y - p.y)*(q.y - p.y) );
      distances[i] += dist; 
    }
  }
  // pick the miminal
  float min = distances[0];
  int minIndex = 0;
  for (int i = 0; i < list.size(); i++) {
    if (distances[i] < min) {
      min = distances[i];
      minIndex = i;
    }
  }
  
  return minIndex;
}

int signum(float number) {
  if (number == 0) {
    return 0;
  } else if (number < 0) {
    return -1;
  } else {
    return 1;
  }
}

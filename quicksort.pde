void quicksort(ArrayList<Vertex> list, int i, int k) {
  if (i < k) {
    int p = partition(list, i, k);
    quicksort(list, i, p - 1);
    quicksort(list, p + 1, k);
  }
}

int partition(ArrayList<Vertex> list, int left, int right) {
  int pivotIndex = choosePivot(list, left, right);
  Vertex pivotVert = list.get(pivotIndex);
  swap(list, pivotIndex, right);
  int storeIndex = left;
  for (int i = left; i < right; i++) {
    Vertex vert = list.get(i);
    if (vert.compareTo(pivotVert) == -1) { // using equivalence relation defined for vertices
      swap(list, i, storeIndex);
      storeIndex += 1;
    }
  }
  swap(list, storeIndex, right);
  return storeIndex;
}

void quicksort_angles(ArrayList<Vertex> list, int i, int k, Vertex P) {
  if (i < k) {
    int p = partition_angles(list, i, k, P);
    quicksort_angles(list, i, p - 1, P);
    quicksort_angles(list, p + 1, k, P);
  }
}

int partition_angles(ArrayList<Vertex> list, int left, int right, Vertex P) {
  int pivotIndex = choosePivot(list, left, right);
  PVector pivotVec = new PVector(list.get(pivotIndex).x - P.x, list.get(pivotIndex).y - P.y);
  //println("pivotVec = " + pivotVec);
  PVector reference = new PVector(0,1);
  swap(list, pivotIndex, right);
  int storeIndex = left;
  for(int i = left; i < right; i++) {
    PVector vec = new PVector(list.get(i).x - P.x, list.get(i).y - P.y);
    //println("  vec = " + vec);
    if (PVector.angleBetween(reference, vec) < PVector.angleBetween(reference, pivotVec)) { // using angle "from" P as a "metric" of equivalence
      swap(list, i, storeIndex);
      storeIndex += 1;
    }
  } 
  swap(list, storeIndex, right);
  return storeIndex;
}

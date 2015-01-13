class Vertex {
  char name;
  float x,y;
  boolean modified;
  
  Vertex(float x, float y) {
    name = nextName;
    nextName += 1;
    this.x = x;
    this.y = y;
    modified = false;
  }
  
  void setModified(boolean val) {
    modified = val;
  }
  
  public void drawVertex() {
    ellipse(this.x, this.y, 5, 5);
    text(name, this.x + 5, this.y - 5);
  }
  
  public float distance(Vertex other) {
    return sqrt( (other.x - this.x)*(other.x - this.x) + (other.y - this.y)*(other.y - this.y) );
  }
  
  public boolean equals(Object object) {
    if ( object instanceof Vertex && (((Vertex)object).x == this.x && ((Vertex)object).y == this.y)  ) {
      return true;
    } else {
      return false;
    }
  }
  
  public String toString() {
    return Character.toString(name);
    //return "(" + x +", " + y + ")";
  }
  
  public int compareTo(Vertex v) {
    final int BEFORE  = -1;
    final int AFTER = 1;
    final int EQUAL = 0;
    
    if (this == v) return EQUAL;
    
    if (this.y < v.y) {
      return BEFORE;
    } else {
      if (this.y == v.y) {
        if (this.x < v.x) {
          return BEFORE;
        } else {
          return AFTER;
        }
      } else {
        return AFTER;
      }
    }
    
  }
  
}

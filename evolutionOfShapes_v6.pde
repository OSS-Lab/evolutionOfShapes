int xsize = 1300;
int ysize = 700;

int nColumns = 6;
int nRows = 5;
int popSize = nRows*nColumns;

int drawBox = 150;
int shapeSize = 30;
int dummy=1;

PShape shapeB;
ArrayList<float[]> vertices;
ArrayList<float[]> newvertices;
int[] nVertices;
int[] xLocs;
int[] yLocs;
float[] fitness;
float[] verticesSet;

float counter = 5.0;
float mutRate = 0.25;

//THE SETUP FUNCTION IS REQUIRED FOR EACH PROGRAM. IT SETS UP THINGS
void setup() {
  //first draw the board and the color mode
  size(xsize, ysize, P2D);    //This command makes a board.
  colorMode(RGB,10);     //This command makes the colormode.
  background(8,8,8);
  frameRate(4);
  
  fitness= new float[popSize];    
  nVertices = new int[popSize];
  vertices = new ArrayList<float[]>();
  newvertices = new ArrayList<float[]>();
  

  //then create a "shape" object with given properties
  for (int i=0; i < popSize; i++) {         
//  nVertices[i] = int(random(4))+2;
    nVertices[i] = 8;

    fitness[i] = 0.0;
    verticesSet = new float[nVertices[i]];
    for (int h=0; h<nVertices[i]; h++) {
      verticesSet[h] = random(2*PI);
    } 
    vertices.add(verticesSet);
    newvertices.add(verticesSet);
//    println(nVertices[i]);
  }
 
  xLocs = new int[popSize];
  yLocs = new int[popSize];

  int k=0;
  for (int i=0; i < nRows; i++) {
      for (int j=0; j < nColumns; j++) {
        k = i*nColumns+j;
        xLocs[k] = j*drawBox+shapeSize;
        yLocs[k] = i*drawBox+shapeSize;
      }
  }
  noLoop();
}


void draw() {
    display();  
}

void mousePressed() {
      //get fitness (user choice)
      for (int k=0; k < popSize; k++) {
        if ((mouseY>yLocs[k]-shapeSize) & (mouseX>xLocs[k]-shapeSize) & (mouseY<yLocs[k]+shapeSize) & 
        (mouseX<xLocs[k]+shapeSize)) {
          if (fitness[k] == 0) {fitness[k] = counter/5;}
          else {fitness[k] += 0.1;}  
        }
      }
      print("selection " + counter + ": "); 
      for (int k=0; k < popSize; k++) {
        print(fitness[k]+",");
      }
      println();
      counter = counter-1.0;
     
     //replicate
     if (counter < 1) {
       replicate();
       counter=5;
       redraw();
     }
}
     
void display() { 
    background(8,8,8);
    for (int k=0; k < popSize; k++) {
      pushMatrix();
      translate(xLocs[k],yLocs[k]);
      shapeB = createShape();
      shapeB.beginShape();
      shapeB.fill(10,0,0); 
      for (int m=0; m < nVertices[k]; m++) { 
         shapeB.curveVertex(shapeSize*cos(vertices.get(k)[m]),shapeSize*sin(vertices.get(k)[m]));
      } 
      shapeB.endShape(CLOSE);
      shape(shapeB);
      popMatrix();
    }
}    


void replicate() {
   int k=0;
   int selected = 0;
   while (k<popSize) {
     selected = int(random(popSize)); 
     if (random(1)<fitness[selected]) {
       if (random(1)<mutRate) {
         mutate(selected);
       }
       float[] newVerticeSet = new float[nVertices[selected]];
       for (int h=0; h<nVertices[selected]; h++) {
         newVerticeSet[h] = vertices.get(selected)[h];
       }
       newvertices.add(newVerticeSet);
       newvertices.remove(0);
       k++;
     }
   }
   for (int i=0; i < popSize; i++) {
     float[] newVerticeSet = new float[nVertices[i]];
     for (int h=0; h<nVertices[i]; h++) {
       newVerticeSet[h] = newvertices.get(i)[h];
     }
     vertices.add(newVerticeSet);
     vertices.remove(0);
   }
   for (int i=0; i < popSize; i++) {
     fitness[i] = 0;
 //    println(newvertices.get(i)[0]);
    }
}

void mutate(int id) { 
//   nVertices[id] = int(random(4))+2; 
    for (int m=0; m < nVertices[id]; m++) {
      vertices.get(id)[m] += randomGaussian();
      if (vertices.get(id)[m] < 0) {vertices.get(id)[m] = 0;}
      if (vertices.get(id)[m] > 2*PI) {vertices.get(id)[m] = 2*PI;}
    }
}

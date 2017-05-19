PImage img;
PImage sorted;

int[] row;
int param = DIFFERENCE; //Blend parameter
int compareType = 0; //Hue by default

ControlP5 cp5;
RadioButton r1,r2,r3,r4;
int[] options = {
                 DIFFERENCE,
                 HARD_LIGHT,
                 SCREEN,
                 LIGHTEST
                };
                
String f = "output";
String extension = ".jpg";

int isBlendActive = 0;
boolean isOn = false;


void settings() {
  selectInput("Select an image file","openFile");
  size(400,400);
}

void openFile(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected "+selection.getAbsolutePath());
    img = loadImage(selection.getAbsolutePath());//converts File to String
    sorted = img.get();
    surface.setSize(img.width,img.height); //reset window size
    setup();
    runSort();
    isOn = true;
    createPanel();
    loop();
  }
}

void setup() {
  surface.setResizable(true);
  noLoop();
}
  
void createPanel() {
  cp5 = new ControlP5(this);
  r1 = cp5.addRadioButton("radioButton1")
          .setPosition(25,50)
          .setSize(40,20)
          .setColorForeground(color(120))
          .setColorActive(color(255))
          .setColorLabel(color(255))
          .setItemsPerRow(5)
          .setSpacingColumn(75)
          .addItem("Difference",1)
          .addItem("Hard Light",2)
          .addItem("Screen",3)
          .addItem("Lightest",4)
          ;
          
  r2 = cp5.addRadioButton("radioButton2")
          .setPosition(25,100)
          .setSize(40,20)
          .setColorForeground(color(120))
          .setColorActive(color(255))
          .setColorLabel(color(255))
          .setItemsPerRow(7)
          .setSpacingColumn(75)
          .addItem("hue",0)
          .addItem("brightness",1)
          .addItem("red",2)
          .addItem("green",3)
          .addItem("blue",4)
          .addItem("alpha",5)
          .addItem("saturation",6)
          ;
          
  r3 = cp5.addRadioButton("radioButton3")
          .setPosition(25, 150)
          .setSize(40,20)
          .setColorForeground(color(120))
          .setColorActive(color(255))
          .setColorLabel(color(255))
          .setItemsPerRow(2)
          .setSpacingColumn(75)
          .addItem("blend off",0)
          .addItem("blend on",1)
          ;
  
  cp5.addButton("save")
     .setPosition(width-50,100)
     .setSize(40,40)
     .setId(0)
     .setLabel("save")
     ;
}

void runSort() {
  sorted = img.get();
  sorted.loadPixels();
  img.loadPixels();
  
  row = new int[sorted.width];
  
  for (int i=0; i<sorted.width*sorted.height; i=i+width){
    for (int j = 0; j < sorted.width; j++) {
      row[j] = sorted.pixels[i+j];
    }
    quickSort(row);
    for (int j = 0; j < sorted.width; j++) {
      sorted.pixels[i+j] = row[j];
    }
    println("sorted row starting at "+i);
  }
}

void draw() {
  //background(img);
  //image(img,0,0);
  //image(sorted, img.width, 0);
  if (!isOn) {
    
  }
  else if (isBlendActive == 1) {
    image(img,0,0);
    blend(sorted,0,0,img.width,img.height,0,0,
          sorted.width,sorted.height,param);
  } else {
    image(sorted,0,0);
  }
}

void mouseClicked() {
  
}

void keyPressed() {
  
  if (key == CODED) {
    if (keyCode == UP) {
      param = DIFFERENCE;
    }
    else if(keyCode == LEFT) {
      param = HARD_LIGHT;
    }
    else if(keyCode == DOWN) {
      param = SCREEN;
    }
    else if(keyCode == RIGHT) {
      param = LIGHTEST;
    }
  }
}

void controlEvent(ControlEvent e) {
  if (e.isFrom(r1)) {
    print("event from "+e.getName()+"\t");
    for (int i=0;i<e.getGroup().getArrayValue().length;i++) {
      print(int(e.getGroup().getArrayValue()[i]));
    }
    println("\t "+e.getValue());
    param = options[int(e.getGroup().getValue()-1)];
  } else if (e.isFrom(r2)) {
    print("event from "+e.getName()+"\t");
    for (int i=0; i<e.getGroup().getArrayValue().length;i++) {
      print(int(e.getGroup().getArrayValue()[i])); 
    }
    println("\t "+e.getValue());
    compareType = (int)e.getValue();
    runSort();
  } else if (e.isFrom(r3)){
    isBlendActive = (int)e.getValue();
  }
  else if (e.isAssignableFrom(Textfield.class)) {
    println("controlevent: accessing a string from controller'"
            +e.getName()+"':"
            +e.getStringValue()
            );
  }
}

public void save() {
  cp5.hide();//hide control panel
  noLoop();//if the loop thread is running, save() is bugged
  selectInput("Save as: ","saveHelper");
}
void saveHelper(File selection) {
  if (selection == null) {
    println("Window was closed or cancelled");
  } else {
    println("User selected "+selection.getAbsolutePath());
    save(selection.getAbsolutePath());
    println("saved!");
  }
  loop();//resume draw
  cp5.show();//show panel
}
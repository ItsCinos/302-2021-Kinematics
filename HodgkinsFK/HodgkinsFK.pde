
Bone bone = new Bone(5);
Bone draggedBone;

float time = 0; // how many seconds have passed since program started


void setup() {
  size(600, 600); 

  //bone.child = new Bone();
  //bone.child.parent = bone;
}

// ticks every 1/60th
void draw() {
  background(128);

  time = millis()/1000.0; // calc time

  if (draggedBone != null) draggedBone.drag();

  bone.calc();
  bone.draw();
}

void mousePressed() {
  //bone = new Bone(5); 

  Bone clickedBone = bone.onClick();

  if (Keys.SHIFT()) {
    if (clickedBone != null) {
      clickedBone.addBone(1);
    }
  } else {
    draggedBone = clickedBone;
  }
}

void mouseReleased() {
  draggedBone = null; // stop dragging
}

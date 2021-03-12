
class Bone {
 
  // relative direction the bone points, radians
  // if 0, then this bone points same way as parent  
  float dir = random(-1, 1);
  
  // length of the bone, in pixels
  float mag = random(50, 150);;  
  
  // references to parent/child bones
  // (implementing linked list)
  Bone parent;
  ArrayList<Bone> children = new ArrayList<Bone>();
  
  boolean isRevolute = true; // can spin?
  boolean isPrismatic = true; // can change length?
  
  float wiggleOffset = random(0, 6.28);
  float wiggleAmp = random(.5f, 2);
  float wiggleTimeScale = random(.25, 1);
      
  // cached / derived values:
  PVector worldStart; // start of bone in world-space
  PVector worldEnd; // end of bone in world-space
  float worldDir = 0; // world-space angle of bone
  int boneDepth = 0; // how deep in the armature (tree) this bone is
  
  Bone(){}
  
  Bone(Bone parent){
  this.parent = parent;
  
  int num = 0;
  Bone p = parent;
  while(p != null){
   num++;
   p = p.parent;
  }
  boneDepth = num;
  }
  
  Bone(int chainLength){
    if(chainLength > 1){      
      addBone(chainLength - 1);          
    }
  }
    
  void addBone (int chainLength){
   if(chainLength < 1) chainLength = 1;
   
   int numOfChildren = (int)random(1, 4);
   
   for(int i = 0; i < numOfChildren; i++){
   Bone newBone = new Bone();
   children.add( newBone );
   newBone.parent = this;
   
   if(chainLength > 1){
    newBone.addBone(chainLength - 1); 
    }   
   }   
  }
    
  void draw(){
        
    line(worldStart.x, worldStart.y, worldEnd.x, worldEnd.y);
    
    fill(100, 100,  200);
    ellipse(worldStart.x, worldStart.y, 20, 20);
    
    for(Bone child : children) child.draw();     
    
    fill(150, 150, 255);
    ellipse(worldEnd.x, worldEnd.y, 10, 10);
  }
  void calc(){
    // calc (bone start)
    
    if(parent!= null){
     worldStart = parent.worldEnd;
     worldDir = parent.worldDir + dir;
    } else { // if we dont have a parent use these default values:
    worldStart = new PVector(100,100);
    worldDir = dir;
    }
    
    worldDir += sin((time + wiggleOffset) * wiggleTimeScale) * wiggleAmp;
    
    // calc (bone end)
    PVector localEnd = PVector.fromAngle(worldDir);
    localEnd.mult(mag);
    
    worldEnd = PVector.add(worldStart, localEnd);
    
    // tell child bone(s) to calculate:
    for(Bone child : children) child.calc();  
  }
  
  Bone onClick(){
    PVector mouse = new PVector(mouseX, mouseY);
    PVector vToMouse = PVector.sub(mouse, worldEnd); // mouse - worldEnd
    if(vToMouse.magSq() < 20 * 20) return this; // if dis to mouse < 20 px, return this bone
    
     // checks all child bones:
    for(Bone child : children){
     Bone b = child.onClick();
     if(b != null) return b;
    }    
    return null;    
  }
  
  void drag(){
   PVector mouse = new PVector(mouseX, mouseY);
   PVector vToMouse = PVector.sub(mouse, worldStart);
   
   if(isRevolute){
   if(parent != null){
   dir = vToMouse.heading() - parent.worldDir;  //atan2(vToMouse.y, vToMouse.x);
   } else {
     dir = vToMouse.heading(); // root bone can point right at mouse
    }
   }   
  if(isPrismatic) mag = vToMouse.mag();  
  }  
}

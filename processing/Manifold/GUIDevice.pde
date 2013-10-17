class GUIDevice extends Device {

  ControlP5 cp5;
  int top, left;

  GUIDevice(String name, ControlP5 cp5, int left, int top) {
    super(name);
    this.cp5 = cp5;
    this.top = top;
    this.left = left;
  }

  int getRight() {
    return 0;
  }
}


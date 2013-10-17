class Device {

  final int HISTORY_SIZE = 512;

  int value = 0;
  int[] valueHistory;
  float normalisedValue = 0;
  float[] normalisedValueHistory;
  boolean[] bangHistory;

  ArrayList<Device> children = new ArrayList<Device>();
  Device parent;
  String name;


  Device(String name) {
    this.name = name;
  }

  // device hierarchy

  void addChild(Device child) {
    children.add(child);
    child.setParent(this);
  }

  void removeChild(Device child) {
    children.remove(child);
    child.setParent(null);
  }

  void setParent(Device parent) {
    this.parent = parent;
  }

  // value forwarding

  void newValue(Device sender) {
    for (Device device : children) {
      device.newValue(sender);
    }
  }

  void bang(Device sender) {
    // if (sender != this) println (name + " got bang from " + sender.name);
    for (Device device : children) {
      device.bang(sender);
    }
  }

  void exit() {
  }
}


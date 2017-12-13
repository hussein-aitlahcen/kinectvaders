class Sprite {
  PImage img;
  String name;
  Sprite(PImage img, String name) {
    this.img = img;
    this.name = name;
  }
}

class Atlas {
  HashMap<String, Sprite> sprites;
  Atlas(Sprite[] sprites) {
    this.sprites = new HashMap<String, Sprite>();
    for(Sprite sprite : sprites) {
      this.sprites.put(sprite.name, sprite);
    }
  }
  Sprite get(String name) {
    return sprites.get(name);
  }
}

Atlas setupAtlas() {
  String assetsPath = "../assets";
  String atlasPath = "../assets/Spritesheet";
  println("Initializing texture atlas.");
  XML atlasData = loadXML(atlasPath + "/sheet.xml");
  PImage atlasImage = loadImage(atlasPath + "/" + atlasData.getString("imagePath"));
  XML[] textures = atlasData.getChildren("SubTexture");
  Sprite[] sprites = new Sprite[textures.length];
  for(int i = 0; i < textures.length; i++) {
    XML currentTex = textures[i];
    String name = currentTex.getString("name");
    int x = currentTex.getInt("x");
    int y = currentTex.getInt("y");
    int w = currentTex.getInt("width");
    int h = currentTex.getInt("height");
    PImage spriteImage = atlasImage.get(x, y, w, h);
    sprites[i] = new Sprite(spriteImage, name);
  }
  println("Texture atlas initialized.");
  return new Atlas(sprites);
}

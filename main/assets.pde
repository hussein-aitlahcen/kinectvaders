// assets.pde ---

// Copyright (C) 2017 Hussein Ait-Lahcen

// Author: Hussein Ait-Lahcen <hussein.aitlahcen@gmail.com>

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 3
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

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

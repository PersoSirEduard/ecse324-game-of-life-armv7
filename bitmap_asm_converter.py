from PIL import Image
import numpy as np
import sys

if len(sys.argv) <= 1:
    print("No input image")
    exit(1)

def rgb_hex565(red, green, blue):
    return "0x%0.4X" % (((blue >> 3) & 0x1f) | (((green >> 2) & 0x3f) << 5) | (((red >> 3) & 0x1f)) << 11)

imgOut = "SpriteImg:"
img = Image.open(sys.argv[1])
img = img.resize((20, 20))
img = img.rotate(-90)
img = img.transpose(method=Image.Transpose.FLIP_LEFT_RIGHT)
pixels = np.array(img)
for y in range(len(pixels)):
    for x in range(len(pixels[y])):
        col = rgb_hex565(pixels[x][y][0], pixels[x][y][1], pixels[x][y][2])
        if x == 0:
            imgOut += f"\n\t.word {col}, "
        elif x == 19:
            imgOut += col
        else:
            imgOut += f"{col}, "

print(imgOut)


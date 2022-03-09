
import sys
from PIL import Image

#img = Image.open('gbj.png')
img = Image.open(sys.argv[1])
xx,yy=img.size
cx=int(xx/2)
cy=int(yy/2)
points=[
[cx-384,cy-448,1, 0],
[cx-256,cy-448,0, 1],
[cx-128,cy-448,1, 2],
[cx    ,cy-448,0, 3],
[cx+128,cy-448,1, 4],

[cx-512,cy-224,1, 5],
[cx-384,cy-224,0, 6],
[cx-256,cy-224,1, 7],
[cx-128,cy-224,0, 8],
[cx    ,cy-224,1, 9],
[cx+128,cy-224,0,10],
[cx+256,cy-224,1,11],

[cx-512,cy    ,0,12],
[cx-384,cy    ,1,13],
[cx-256,cy    ,0,14],
[cx-128,cy    ,1,15],
[cx    ,cy    ,0,16],
[cx+128,cy    ,1,17],
[cx+256,cy    ,0,18],

[cx-384,cy+224,0,19],
[cx-256,cy+224,1,20],
[cx-128,cy+224,0,21],
[cx    ,cy+224,1,22],
[cx+128,cy+224,0,23]

]
#print(points)

img = img.convert("RGBA")
pix = img.load()

for p in range(0,24):
    tri = Image.new('RGBA', (256, 224))
    trix=tri.load()
    for x in range(points[p][0],points[p][0]+256):
        for y in range(points[p][1],points[p][1]+224):
            trix[x-points[p][0],y-points[p][1]]=pix[x,y]
    if (points[p][2]==0):
        for x in range(0,128):
            s = 1.75 * x
            for y in range(int(s),224):
                trix[x,y]=(255, 255, 255,0)
                trix[255-x,y]=(255, 255, 255,0)
    else:
        for x in range(0,128):
            s = 1.75 * x
            for y in range(int(s),224):
                trix[x,223-y]=(255, 255, 255,0)
                trix[255-x,223-y]=(255, 255, 255,0)
        
    tri = tri.convert("RGBA")
    if (points[p][2]==0):
        #tri = tri.transpose(Image.FLIP_TOP_BOTTOM)
        tri = tri.transpose(Image.ROTATE_180)
        
    fname = str(points[p][3])+'.png' 
    tri.save(fname)



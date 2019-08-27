#pip3 install pillow
#run python3 exportIcon.py
import sys
import os
import PIL.Image
imgNames = [
            ((40,40),"icon-40.png"),
            ((80,80),"icon-40@2x.png"),
            ((120,120),"icon-40@3x.png"),
            

            ((120,120),"icon-60@2x.png"),
            ((180,180),"icon-60@3x.png"),
            
            ((76,76),"icon-76.png"),
            ((152,152),"icon-76@2x.png"),
            
            ((167,167),"icon-83.5@2x.png"),
            
            ((20,20),"icon-notify.png"),
            ((40,40),"icon-notify@2x.png"),
            ((60,60),"icon-notify@3x.png"),
            
            ((29,29),"icon-small.png"),
            ((58,58),"icon-small@2x.png"),
            ((87,87),"icon-small@3x.png"),
            
            ]
 
im = PIL.Image.open("icon-1024.png")
i = 0
for i in range(len(imgNames)):
	imt = im
	size = imgNames[i][0] 
	#print size
	name = imgNames[i][1]
	#print name+type(name)
	imt_r = imt.resize(size,PIL.Image.LANCZOS)
    #ANTIALIAS) resize image with high-quality
	imt_r.save(name)
	i = i+1

# 创建Contents.json文件
content = '''
{
  "images" : [
    {
      "size" : "20x20",
      "idiom" : "iphone",
      "filename" : "icon-notify@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "20x20",
      "idiom" : "iphone",
      "filename" : "icon-notify@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "icon-small@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "icon-small@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "icon-40@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "icon-40@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "icon-60@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "icon-60@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "20x20",
      "idiom" : "ipad",
      "filename" : "icon-notify.png",
      "scale" : "1x"
    },
    {
      "size" : "20x20",
      "idiom" : "ipad",
      "filename" : "icon-notify@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "icon-small.png",
      "scale" : "1x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "icon-small@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "icon-40.png",
      "scale" : "1x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "icon-40@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "icon-76.png",
      "scale" : "1x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "icon-76@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "83.5x83.5",
      "idiom" : "ipad",
      "filename" : "icon-83.5@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "1024x1024",
      "idiom" : "ios-marketing",
      "filename" : "icon-1024.png",
      "scale" : "1x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
'''
f = open('Contents.json', 'w')
f.write(content)

from libNDWI import calculateNDVI


def processCallback(percent, total_amount, finish_amount, message):
    print(percent, total_amount, finish_amount, message)

sourceFile = "/media/cowerling/Windows/IDIPData/basic/landsat/LC08_L2SP_122038_20210409_20210416_02_T1_SR.tif"
targetFile = "/home/cowerling/下载/ndwi.tif"

calculateNDVI(sourceFile, targetFile, processCallback)

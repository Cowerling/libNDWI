# cython: language_level=3

from osgeo import gdal
import numpy as np


cdef public calculateNDVI(sourceFile, targetFile, processCallback):
    dataset = gdal.Open(sourceFile)

    if dataset is None and dataset.RasterCount < 7:
        raise Exception("Bad Images")

    dataset_ndwi = dataset.GetDriver().Create(targetFile,
                                              xsize=dataset.RasterXSize, ysize=dataset.RasterYSize, bands=1,
                                              eType=gdal.GDT_Float32)
    dataset_ndwi.SetGeoTransform(dataset.GetGeoTransform())
    dataset_ndwi.SetSpatialRef(dataset.GetSpatialRef())

    band_3 = dataset.GetRasterBand(3)
    band_5 = dataset.GetRasterBand(5)

    band = dataset_ndwi.GetRasterBand(1)

    x_size = dataset.RasterXSize
    total_amount = dataset.RasterYSize * dataset.RasterXSize
    finish_amount = 0

    if processCallback is not None:
        processCallback(finish_amount / total_amount, total_amount, finish_amount, "strat")

    for i in range(0, dataset.RasterYSize):
        data_3 = band_3.ReadAsArray(0, i, x_size, 1)
        data_5 = band_5.ReadAsArray(0, i, x_size, 1)

        data_ndwi = (data_3 - data_5) / (data_3 + data_5)
        data_ndwi[np.isnan(data_ndwi)] = 0.

        band.WriteArray(data_ndwi, 0, i)

        finish_amount = (i + 1) * x_size

        if processCallback is not None:
            processCallback(finish_amount / total_amount, total_amount, finish_amount, None)

    dataset_ndwi.FlushCache()
    dataset = None
    dataset_ndwi = None

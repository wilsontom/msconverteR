# msconverteR

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Build Status](https://travis-ci.org/wilsontom/msconverteR.svg?branch=master)](https://travis-ci.org/wilsontom/msconverteR) [![Build status](https://ci.appveyor.com/api/projects/status/9qjt5jk4u6ty98uh/branch/master?svg=true)](https://ci.appveyor.com/project/wilsontom/msconverter/branch/master) ![License](https://img.shields.io/badge/license-GNU%20GPL%20v3.0-blue.svg "GNU GPL v3.0")


### Installation & Usage

To use `msconverteR` you must have a working installation of [Docker](https://www.docker.com/). [See here](https://docs.docker.com/install/) for details on how to install.

Once Docker is installed; `msconverteR` can be installed directly from GitHub

```r
remotes::install_github('wilsontom/msconverteR')

```

To use msconverteR the [chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:latest](https://hub.docker.com/r/chambm/pwiz-skyline-i-agree-to-the-vendor-licenses) docker image needs to available. The first time you use msconverteR you should run the `get_pwiz_container()` function which will pull the image from Docker Hub.

```r
library(msconverteR)
get_pwiz_container()
```

All file conversions are performed by the `convert_files` function. Conversion parameters are passed to the the `args` parameter in the same way as they would be for `msconvert` except that the `--filter` prefix is omitted. 

```
> rawfile <- 'inst/QC01.raw'

> convertFiles(rawfiles, outpath, args = 'peakPickingtrue1-')

format: mzML 
    m/z: Compression-None, 64-bit
    intensity: Compression-None, 32-bit
    rt: Compression-None, 64-bit
ByteOrder_LittleEndian
 indexed="true"
outputPath: .
extension: .mzML
contactFilename: 
runIndexSet: 

spectrum list filters:
  peakPicking true1-
  
chromatogram list filters:
  
filenames:
  QC01.raw
  
processing file: QC01.raw
calculating source file checksums
writing output file: .\QC1.mzML
```




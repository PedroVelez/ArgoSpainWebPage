# Argo Spain Web Processing Pipeline

<a href="https://www.argoespana.es"><img src="https://www.argoespana.es/imagenes/logoargoes.png" alt="SST" width="300""></a>

[![DOI](https://zenodo.org/badge/244975526.svg)](https://doi.org/10.5281/zenodo.13898771)

![MATLAB](https://img.shields.io/badge/MATLAB-data_processing-orange) ![Bash](https://img.shields.io/badge/Bash-pipeline-blue) ![Leaflet](https://img.shields.io/badge/Leaflet-interactive_maps-green) ![Status](https://img.shields.io/badge/status-operational-brightgreen) ![License](https://img.shields.io/badge/license-institutional-lightgrey)

This repository contains the scripts used to generate and update the Argo Spain web page [www.argoespana.es](https://www.argoespana.es). The system automates the transformation of raw Argo data into web-ready products through MATLAB-based scrips organized by a Bash script.

[Argo España status](https://www.argoespana.es/argoesstatus.html)
[Argo España region status](https://www.argoespana.es/argoregionstatus.html)
[Argo España report](https://www.argoespana.es/report.txt)

## System Overview
Main components:

- **Bash** – pipeline organization
- **MATLAB** – data processing and product generation  
- **Leaflet** – interactive web maps  
- **HTML outputs** – web pages and figures  

## Repository Structure

```
.
├── argoSpainWebPage.sh
├── configWebPage.m
├── createDataSet.m
├── createDataSetMap.m
├── createDataSetMapLLet.m
├── createDataSetStatus/
│   ├── createDataSetStatus_FunctionMetadata.m
│   ├── createDataSetStatus_FunctionProfiles.m
│   ├── createDataSetStatus_FunctionTechnicalData.m
│   ├── createDataSetStatus_FunctionSections.m
│   ├── createDataSetStatus_FunctionFigures.m
│   └── createDataSetStatus_FunctionReport.m
├── data/
├── html/
└── log/
```

## Processing Workflow
The scrips transforms Argo float data → web visualization products:

```
Argo Data
         │
         ▼
Dataset Generation (createDataSet)
         │
         ▼
Map Generation (createDataSetMap / createDataSetMapLLet)
         │
         ▼
Tables and Statistics (createDataSetTable)
         │
         ▼
Float Status Pages (createDataSetStatus)
         │                 │
         │                 ├── Metadata
         │                 ├── Profiles
         │                 ├── Technical data
         │                 ├── Sections
         │                 └── Figures
         │
         ▼
Web Content Generation (argoesstatus.html , argoregionstatus.html)
         │
         ▼
Automatic Reporting by email (sendDataSetReport)
```

## Main Script
The entire workflow is executed by the Bash script:
```
argoSpainWebPage.sh
```
This script:
- Organize the full processing pipeline
- Runs MATLAB scripts sequentially
- Manages logs
- Cleans outdated files
- Sends automatic reports (email)

## MATLAB Modules

### Configuration
```
configWebPage.m
```
Defines:
- Directory paths
- Data locations
- Website output directories
- General configuration parameters

### Dataset Generation
```
createDataSet.m
```
Creates the main datasets used by the system.Actually there are only two data sets, but it may be configurated to have more data sets:
```
dataArgoSpain.mat
dataArgoInterest.mat
```

These datasets include information about:
- Argo Spain floats
- regional floats of interest
- profile data and metadata

### Map Generation
#### Static maps
Generates static visualizations of float positions.
```
createDataSetMap.m
```

#### Interactive maps
Creates Leaflet-based interactive maps used on the web interface.
```
createDataSetMapLLet.m
```
[argoesstatus.html    : ArgoEspaña status](https://www.argoespana.es/argoesstatus.html)
[argoregionstatus.html: Iberian Basin region status](https://www.argoespana.es/argoregionstatus.html)

#### Float Status Pages
The float monitoring pages are generated using several modular scripts.
Main processing:
```
createDataSetStatus
```

Supporting modules:

```
createDataSetStatus_FunctionMetadata.m
createDataSetStatus_FunctionProfiles.m
createDataSetStatus_FunctionTechnicalData.m
createDataSetStatus_FunctionSections.m
createDataSetStatus_FunctionFigures.m
createDataSetStatus_FunctionReport.m
```

These modules generate:
- Float metadata
- Profile information
- Technical diagnostics
- Vertical sections
- Figures and visualizations
- Summary reports

#### Logs
Execution logs are stored in:
```
/log/
```

Example log files:

```
createDataSet.log
createDataSetMapLLet.log
createDataSetStatus.log
```

## Authors

Argo Spain Team
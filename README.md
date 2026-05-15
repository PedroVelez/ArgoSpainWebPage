# Argo Spain Web Page

<p align="left">
<a href="https://www.argoespana.es">
<img src="https://www.argoespana.es/imagenes/logoargoes.png" width="500">
</a>
</p>

[![DOI](https://zenodo.org/badge/244975526.svg)](https://doi.org/10.5281/zenodo.13898771)
![MATLAB](https://img.shields.io/badge/MATLAB-data_processing-orange)
![Bash](https://img.shields.io/badge/Bash-pipeline-blue)
![Leaflet](https://img.shields.io/badge/Leaflet-interactive_maps-green)
![Status](https://img.shields.io/badge/status-operational-brightgreen)
![License](https://img.shields.io/badge/license-institutional-lightgrey)

This repository contains the operational scripts and processing pipeline used to generate and maintain the Argo Spain web platform:

https://www.argoespana.es

The system automatically transforms Argo float data into web-ready products including interactive maps, operational summaries, tables, float monitoring pages, technical diagnostics, and automatic reports. The workflow is mainly based on MATLAB processing modules coordinated through Bash scripts, while Leaflet is used for interactive web visualization.

## Web Products

- [Argo Spain Main Page](https://www.argoespana.es)
- [Argo Spain Status Map](https://www.argoespana.es/argoesstatus.html)
- [Argo Spain Interactive Map](https://www.argoespana.es/argoesstatus_mapa.html)
- [Iberian Basin Regional Status](https://www.argoespana.es/argoregionstatus.html)
- [Argo Spain Float Table](https://www.argoespana.es/argoesstatus_tabla.html)
- [Argo Spain Float Table (TXT)](https://www.argoespana.es/argoesstatus_tabla.txt)
- [Argo Spain Summary](https://www.argoespana.es/argoessummary.html)
- [Argo Spain Technical Report](https://www.argoespana.es/argoesreport.txt)

## System Overview

Main components:

- **Bash** – workflow and pipeline orchestration
- **MATLAB** – data ingestion, processing, diagnostics, and figure generation
- **Leaflet** – interactive web maps
- **HTML outputs** – operational web products and reports

## Repository Structure

```text
.
├── argoSpainWebPage.sh
├── configWebPage.m
├── createDataSet.m
├── createDataSet_GeoJSON.m
├── createDataSet_Table.m
├── createDataSet_Summary.m
├── createDataSetStatus/
│   ├── createDataSetStatus_FunctionMetadata.m
│   ├── createDataSetStatus_FunctionProfiles.m
│   ├── createDataSetStatus_FunctionTechnicalData.m
│   ├── createDataSetStatus_FunctionSections.m
│   ├── createDataSetStatus_FunctionFigures.m
│   ├── createDataSetStatus_FunctionReport.m
│   └── createDataSetStatus_FunctionTrajectory.m
├── data/
├── html/
└── log/
```

## Processing Workflow

The processing chain transforms operational Argo data into monitoring and visualization products for the Argo Spain website.

```text
Argo GDAC Data
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
Operational Summary (createDataSetSummary)
         │
         ▼
Float Status Pages (createDataSetStatus)
         │                 │
         │                 ├── Metadata
         │                 ├── Profiles
         │                 ├── Technical diagnostics
         │                 ├── Trajectories
         │                 ├── Vertical sections
         │                 └── Figures and reports
         │
         ▼
Web Content Generation
         │
         ▼
Automatic Reporting by Email
```

## Main Script

The complete operational workflow is executed through:

```bash
argoSpainWebPage.sh
```

This script:

- Organizes the complete processing pipeline
- Executes MATLAB modules sequentially
- Updates web products
- Handles execution logs
- Cleans obsolete files
- Generates automatic reports
- Sends notification emails

## MATLAB Modules

### Configuration

```matlab
configWebPage.m
```

Defines:

- Directory paths
- Data source locations
- Output directories
- Website configuration
- Processing parameters

### Dataset Generation

```matlab
createDataSet.m
```

Generates the datasets used by the operational system.  
Currently the workflow uses two principal datasets:

```matlab
dataArgoSpain.mat
dataArgoInterest.mat
```

These datasets include:

- Argo Spain floats
- Regional floats of interest
- Float metadata
- Profile information
- Position data
- Temporal information
- Technical parameters

### Map Generation

#### Static Maps

Generates gJson files that are read by the hmtl files static visualizations of float trajectories and positions.

```matlab
createDataSetMap.m
```

#### Interactive Maps

Creates Leaflet-based interactive maps integrated into the web interface.

```matlab
createRegionGeoJSON.m
createDataSet_GeoJSON.m
```

Associated web pages:

- [argoregionstatus.html : Iberian Basin regional status](https://www.argoespana.es/argoregionstatus.html)
- [argoesstatus.html : Argo Spain status](https://www.argoespana.es/argoesstatus.html)

### Tables and Summaries

#### Float Tables

Creates operational tables summarizing float activity and metadata.

```matlab
createDataSet_Table.m
```

#### Operational Summary

Generates summary statistics and regional monitoring products.

```matlab
createDataSet_Summary.m
```

### Float Status Pages

The float monitoring pages are generated through a modular processing structure.

Main processing:

```matlab
createDataSetStatus
```

Supporting modules:

```matlab
createDataSetStatus_FunctionMetadata.m
createDataSetStatus_FunctionProfiles.m
createDataSetStatus_FunctionTechnicalData.m
createDataSetStatus_FunctionSections.m
createDataSetStatus_FunctionFigures.m
createDataSetStatus_FunctionReport.m
createDataSetStatus_FunctionTrajectory.m
```

These modules generate:

- Float metadata pages
- Profile summaries
- Technical diagnostics
- Float trajectories
- Vertical oceanographic sections
- Figures and scientific visualizations
- Automatic monitoring reports

### Logs

Execution logs are stored in:

```text
/log/
```
## Data Sources

The system processes Argo float observations distributed through the international Argo GDAC infrastructure.

Primary sources include:

- Coriolis GDAC
- Global Argo Program
- Regional Argo deployments
- Argo Spain operational datasets

## Operational Purpose

This repository supports the operational monitoring and visualization activities of Argo Spain by providing:

- Near real-time float monitoring
- Regional ocean observing products
- Interactive float visualization
- Technical diagnostics
- Automatic operational reporting
- Scientific and outreach web products

## Authors

Argo Spain Team
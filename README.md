
## Travis

[![Build Status](https://travis-ci.org/chembl/GLaDOS.svg?branch=master)](https://travis-ci.org/chembl/GLaDOS)

## Ghost Inspector

 [![ChEMBL New UI (Basic)](https://api.ghostinspector.com/v1/suites/5b59d19924a45131ae3c2a6a/status-badge
)](https://api.ghostinspector.com/v1/suites/5b59d19924a45131ae3c2a6a/status-badge
 "ChEMBL New UI (Basic)")
 
 [![ChEMBL New UI (Report Cards)](https://api.ghostinspector.com/v1/suites/5b5b1a1e24a45131ae42101a/status-badge
)](https://api.ghostinspector.com/v1/suites/5b5b1a1e24a45131ae42101a/status-badge
 "ChEMBL New UI (Report Cards)")
 
[![(ReportCards - Compound)](https://api.ghostinspector.com/v1/suites/5b717147f818e30945119296/status-badge
)](https://api.ghostinspector.com/v1/suites/5b717147f818e30945119296/status-badge
 "ReportCards - Compound")
 
 [![(ReportCards - Downloads)](https://api.ghostinspector.com/v1/suites/5c18be9ec4f77e2d97458162/status-badge
)](https://api.ghostinspector.com/v1/suites/5c18be9ec4f77e2d97458162/status-badge
 "ReportCards - Downloads")
 


# I think we can put our differences behind us... for science...
![](https://upload.wikimedia.org/wikipedia/en/b/bf/Glados.png)


## Diagrams

Here you can find some informal diagrams that help to understand how some components work

### Paginated Collections

* [Item Columns](https://docs.google.com/drawings/d/1RjgbMwToiI1m2rX-UM2QRy5_gBUk0iHZJ2frL5v6OIE/edit?usp=sharing)

### Visualisations

#### Heatmap

* [ChEMBL Dasboard Basic Layout](https://docs.google.com/drawings/d/1fLOw-IBkRmQct4tv9WeoRjWc8mQnrOj50PAZ6JE2w4o/edit?usp=sharing)
* [Heatmap Concpetual Design](https://docs.google.com/drawings/d/18dPoA2wI1q62aBWMOBYAVQ7TIza_Mbk28yxL6hK10nE/edit?usp=sharing)
* [Heatmap Window System 1](https://docs.google.com/drawings/d/1hbmanZRe6VHKpHCoCtPfcCM3Er8d4TCeveOz2Rm3QaI/edit?usp=sharing)
* [Heatmap Window System 2](https://docs.google.com/drawings/d/1XuJ9947pq0nkOBlixAWTiLaVRxN1mBYC--FUlDIXbyI/edit?usp=sharing)
* [Heatmap Window System 3](https://docs.google.com/drawings/d/1QoG5OPFewKQ5I2N3-My83hKKQOScM8_Lc5SRAD1D7zM/edit?usp=sharing)
* [Heatmap Visual Layout](https://docs.google.com/drawings/d/1_K7JTZDZYPw0i_hLy-ApYsNI264edBrJmoDetG2FgVw/edit?usp=sharing)

### Molecule Features Icons

* [All Features](https://drive.google.com/file/d/17t61ULFxI5OznryZTwzedBuaWOiC-qHz/view?usp=sharing)
* [SVG Icons](https://drive.google.com/open?id=1ZFjAxhsA_PrIgBLvGqbZT8ijofdUSuK2)
* [Icon Credits](https://sites.google.com/view/icon-credits/home)

### Interface Icons and Logo
* [All Assets](https://drive.google.com/open?id=1PZQz6a-AU_NAPyIr7Z010qVVI6u4inwV)
* [ChEMBL Logo Files](https://drive.google.com/open?id=1wScvQgSmJczsjYFF3Rr93xq6O2mZF7TQ)

### Design Components Page
https://www.ebi.ac.uk/chembl/beta/design_components/

## Running it locally with Docker

This requires [Docker](https://www.docker.com/get-started) installed and running.
Copy and rename the [minimal_dev_config](/configurations/minimal_dev_config.yml) file to ```configurations/config.yml```, add the elasticsearch endpoint information.
Then run the following command to create and start the instance:

```
$ docker-compose up
```

The entry point for the images is [fireitup.sh](/fireitup.sh) file, there an instance of the service will be started listening on
the port **8000**.


## Chemvue front (VueJS 3)

VueJS 3 requires its [client](https://cli.vuejs.org/) which can be installed by running:

```bash
$ npm install -g @vue/cli
```

GLaDOS collectstatic function ```CONFIG_FILE_PATH=configurations/config.yml ./manage_glados_no_install.sh collectstatic --no-input```
will build and place chemvue static files on ```src/glados/v``` folder, which will be served by Django.

In order to take advantage of VueJS's [hot reload](https://vue-loader.vuejs.org/guide/hot-reload.html) capabilities while developing, on chemvue dir run:

```bash
$ npm run start
```

To build for production run:

```bash
$ npm run build
```
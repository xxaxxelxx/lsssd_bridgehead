# ***LSSSD | BRIDGEHEAD***
# Bridgehead Module
# Part of Dockerized LIQUIDSOAP STREAM SILENCE DETECTOR

[xxaxxelxx/lsssd_bridgehead](https://index.docker.io/u/xxxaxxelxx/lsssd_bridgehead)

## Synopsis
This repo is part of a dockerized distributed stream silence detector system consisting of following elements:
* [xxaxxelxx/lsssd_bridgehead](https://github.com/xxaxxelxx/lsssd_bridgehead)
* [xxaxxelxx/lsssd_snmpd](https://github.com/xxaxxelxx/lsssd_snmpd)
* [xxaxxelxx/lsssd_maintenancer](https://github.com/xxaxxelxx/lsssd_maintenancer)
* [xxaxxelxx/lsssd_volumecontrol](https://github.com/xxaxxelxx/lsssd_volumecontrol)
* [xxaxxelxx/lsssd_detector](https://github.com/xxaxxelxx/lsssd_detector)

The running docker container provides a service for very special stream silence detecting purposes usable for a distributed architecture.
It presumably will not fit for you, but it is possible to tune it. If you need some additional information, please do not hesitate to ask.

This [xxaxxelxx/lsssd_bridgehead] repo is an essential part of a complex compound used for the stream silence detector.














### Example
```bash
$ docker run -d --name liquidsoap_MOUNTPOINT-ID --link icecast_player:icplayer --restart=always xxaxxelxx/xx_liquidsoap MOUNTPOINT-ID
```
***

## License

[MIT](https://github.com/xxaxxelxx/lsssd_bridgehead/blob/master/LICENSE.md)

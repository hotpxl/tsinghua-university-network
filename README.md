# Tsinghua University Network

[![npm version](https://badge.fury.io/js/tsinghua-university-network.svg)](http://badge.fury.io/js/tsinghua-university-network)

[![NPM](https://nodei.co/npm/tsinghua-university-network.png)](https://nodei.co/npm/tsinghua-university-network/)

## Introduction

An interface of Tsinghua University Network for JavaScript

## Installation

Simple as `npm install tsinghua-university-network`!

## API

### Login

    login(username, password, callback)

`callback` will be called as `callback(error, dataUsage)`, where `dataUsage` represents gigabytes used so far this month.

### List connected clients

    getActiveConnections(username, password, callback)

`callback` will be called as `callback(error, listOfClients)`, where `listOfClients` is of style `[{ip: ..., checksum: ...}, ...]`.

### Logout

    logout(username, password, ip, checksum, callback)

`callback` will be calle das `callback(error)`. Yes, `ip` and `checksum` would be best chained with `getActiveConnections`.

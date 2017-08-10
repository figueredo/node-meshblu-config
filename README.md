# meshblu-config
Meshblu Config from environment or JSON file

## Install

```bash
npm install meshblu-config
```

## Usage

```js
var MeshbluConfig = require('meshblu-config');
var meshbluConfig = new MeshbluConfig();
var config = meshbluConfig.generate({});

var Meshblu = require('meshblu');
var meshblu = Meshblu.createConnection(config);
```

## Options (showing default values)
# Functions
### Constructor
| Parameter | Type   | Required| Description                          |
| ----------| -------| --------| -------------------------------------|
| options   | object | no      | can contain any of these keys: envVars, defaultFilename, env |
------------------------------------------
```javascript
var meshbluConfig = new MeshbluConfig({envVars: {uuid: "MESHBLU_UUID", resolveSrv: "MESHBLU_RESOLVE_SRV"}})
var meshbluConfig = new MeshbluConfig({defaultFilename: './something-like-meshblu.json'})
var meshbluConfig = new MeshbluConfig({env: {"MESHBLU_UUID": "the-uuid"}})
```

### generate
Parse the default file, environment, and data and return the combined configuration

| Parameter | Type   | Required| Description                          |
| ----------| -------| --------| -------------------------------------|
| data       | object | no     | Data to process |
------------------------------------------
```javascript
var data = meshbluConfig.generate()
```

# Advanced Functions

### get
Returns the current config

| Parameter | Type   | Required| Description                          |
| ----------| -------| --------| -------------------------------------|
------------------------------------------
```javascript
var data = meshbluConfig.get();
```

### fromFile
Loads any values from the JSON file into the config

| Parameter | Type   | Required| Description                          |
| ----------| -------| --------| -------------------------------------|
| filename  | string | no     | JSON file to parse, defaults to ``./meshblu.json` |
------------------------------------------
```javascript
meshbluConfig.fromFile('./filename.json')
var data = meshbluConfig.get();
```

### fromEnv
Loads any values from the env

| Parameter | Type   | Required| Description                          |
| ----------| -------| --------| -------------------------------------|
| env       | object | no     | Environment to use, defaults to `process.env` |
------------------------------------------
```javascript
meshbluConfig.fromEnv({"MESHBLU_UUID": "the-uuid"})
var data = meshbluConfig.get();
```

### fromData
Loads any values from the env

| Parameter | Type   | Required| Description                          |
| ----------| -------| --------| -------------------------------------|
| data      | object | yes    | Data to use |
------------------------------------------
```javascript
meshbluConfig.fromData({uuid: "the-uuid"})
var data = meshbluConfig.get();
```

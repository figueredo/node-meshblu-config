# meshblu-config
Meshblu Config from environment or JSON file

## Install

```bash
npm install meshblu-config
```

## Usage

```js
var MeshbluConfig = require('meshblu-config');
var meshbluConfig = new MeshbluConfig({});
```

## Options

+-------------------+------------------+
| Option            | Default Value    |
+===================+==================+
| `filename`        | `./meshblu.json` |
| `uuid_env_name`   | `MESHBLU_UUID`   |
| `token_env_name`  | `MESHBLU_TOKEN`  |
| `server_env_name` | `MESHBLU_SERVER` |
| `port_env_name`   | `MESHBLU_PORT`   |
+-------------------+------------------+

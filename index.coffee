_ = require 'lodash'
fs = require 'fs'

class Config
  constructor: (@options={}) ->
    @filename = @options.filename ? './meshblu.json'
    @uuid_env_name = @options.uuid_env_name ? 'MESHBLU_UUID'
    @token_env_name = @options.token_env_name ? 'MESHBLU_TOKEN'
    @server_env_name = @options.server_env_name ? 'MESHBLU_SERVER'
    @port_env_name = @options.port_env_name ? 'MESHBLU_PORT'

  parseMeshbluJSON: ->
    JSON.parse fs.readFileSync @filename

  toJSON: =>
    try meshbluJSON = @parseMeshbluJSON()

    _.defaults {
      uuid:   process.env[@uuid_env_name]
      token:  process.env[@token_env_name]
      server: process.env[@server_env_name]
      port:   process.env[@port_env_name]
    }, meshbluJSON

module.exports = Config

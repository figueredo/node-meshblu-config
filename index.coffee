_ = require 'lodash'

class Config
  constructor: (@filename) ->

  toJSON: =>
    try meshbluJSON = _.cloneDeep(require @filename)

    _.defaults {
      uuid:   process.env.MESHBLU_UUID
      token:  process.env.MESHBLU_TOKEN
      server: process.env.MESHBLU_SERVER
      port:   process.env.MESHBLU_PORT
    }, meshbluJSON

module.exports = Config

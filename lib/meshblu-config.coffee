_ = require 'lodash'
fs = require 'fs'
Encryption = require 'meshblu-encryption'

class MeshbluConfig

  constructor: (@_options) ->
    _.defaults @, @toJSON()

  toJSON: =>
    return @constructor.toJSON @_options

  @toJSON: (options) ->
    options = @_getOptionsWithDefaults options
    {auth, serviceName} = options
    envJSON = @_getEnvJSON options
    try meshbluJSON = @_parseMeshbluJSON options
    json = _.defaults {}, auth, { serviceName }, envJSON, meshbluJSON
    return @_compact json

  @_getOptionsWithDefaults: (options) ->
    return _.defaults {}, options, {
      env                   : process.env
      auth                  : {}
      filename              : './meshblu.json'

      uuid_env_name         : 'MESHBLU_UUID'
      token_env_name        : 'MESHBLU_TOKEN'

      protocol_env_name     : 'MESHBLU_PROTOCOL'
      hostname_env_name     : 'MESHBLU_HOSTNAME'
      port_env_name         : 'MESHBLU_PORT'

      service_env_name      : 'MESHBLU_SERVICE'
      domain_env_name       : 'MESHBLU_DOMAIN'
      secure_env_name       : 'MESHBLU_SECURE'

      private_key_env_name  : 'MESHBLU_PRIVATE_KEY'
      resolve_srv_env_name  : 'MESHBLU_RESOLVE_SRV'

      service_name_env_name : 'MESHBLU_SERVICE_NAME'
    }

  @_parseMeshbluJSON: ({filename}) ->
    return JSON.parse fs.readFileSync filename

  @_getEnvJSON: (options={}) ->
    { env } = options
    return {} unless env?
    return {
      uuid       : env[ options.uuid_env_name ]
      token      : env[ options.token_env_name ]

      serviceName: env[ options.service_name_env_name ]

      protocol   : env[ options.protocol_env_name ]
      hostname   : env[ options.hostname_env_name ]
      port       : env[ options.port_env_name ]

      service    : env[ options.service_env_name ]
      domain     : env[ options.domain_env_name ]
      secure     : env[ options.secure_env_name ] && env[ options.secure_env_name ] != 'false'

      privateKey : @_getPrivateKey options
      resolveSrv : env[ options.resolve_srv_env_name ] && env[ options.resolve_srv_env_name ] == 'true'
    }

  @_getPrivateKey: (options={}) ->
    return unless options.env[options.private_key_env_name]?
    return Encryption.fromJustGuess(options.env[options.private_key_env_name]).toPem()

  @_compact: (obj) ->
    compactedObj = {}
    _.each obj, (value, key) =>
      compactedObj[key] = value if value?
      compactedObj[key] = value.trim() if value?.trim?
    return compactedObj

module.exports = MeshbluConfig

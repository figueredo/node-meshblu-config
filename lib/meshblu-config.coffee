_ = require 'lodash'
fs = require 'fs'

class MeshbluConfig
  constructor: (@auth={}, options={}) ->
    @filename = options.filename ? './meshblu.json'

    @uuid_env_name = options.uuid_env_name ? 'MESHBLU_UUID'
    @token_env_name = options.token_env_name ? 'MESHBLU_TOKEN'

    @protocol_env_name = options.protocol_env_name ? 'MESHBLU_PROTOCOL'
    @hostname_env_name = options.hostname_env_name ? 'MESHBLU_HOSTNAME'
    @port_env_name = options.port_env_name ? 'MESHBLU_PORT'

    @service_env_name = options.service_env_name ? 'MESHBLU_SERVICE'
    @domain_env_name  = options.domain_env_name  ? 'MESHBLU_DOMAIN'
    @secure_env_name  = options.secure_env_name  ? 'MESHBLU_SECURE'

    @private_key_env_name = options.private_key_env_name ? 'MESHBLU_PRIVATE_KEY'
    @resolve_srv_env_name = options.private_key_env_name ? 'MESHBLU_RESOLVE_SRV'

  parseMeshbluJSON: ->
    JSON.parse fs.readFileSync @filename

  toJSON: =>
    try meshbluJSON = @parseMeshbluJSON()

    meshbluJSON = _.defaults @auth, {
      uuid:  process.env[@uuid_env_name]
      token: process.env[@token_env_name]

      protocol: process.env[@protocol_env_name]
      hostname: process.env[@hostname_env_name]
      port:     process.env[@port_env_name]

      service: process.env[@service_env_name]
      domain:  process.env[@domain_env_name]
      secure:  _.lowerCase(process.env[@secure_env_name]) != 'false'

      privateKey: process.env[@private_key_env_name]
      resolveSrv: process.env[@resolve_srv_env_name] == 'true'
    }, meshbluJSON

    return @compact meshbluJSON

  compact: (obj) =>
    compactedObj = {}

    _.each obj, (value, key) =>
      compactedObj[key] = value if value?
      compactedObj[key] = value.trim() if value?.trim?

    compactedObj

module.exports = MeshbluConfig

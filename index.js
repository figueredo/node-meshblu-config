const _ = require("lodash")
const fs = require("fs-extra")
const Validators = require("./lib/validators")

class MeshbluConfig {
  constructor(options) {
    _.bindAll(this, Object.getOwnPropertyNames(MeshbluConfig.prototype))

    options = options || {}

    if (options.auth || options.uuid || options.token || options.domain || options.resolveSrv || options.hostname || options.host || options.protocol) {
      throw new Error("MeshbluConfig no longer accepts legacy parameters in the constructor, see documentation")
    }

    this.env = options.env || process.env
    this.defaultFilename = options.defaultFilename || "./meshblu.json"
    this.intializeEnvOptions(options.envOptions || {})
    this.initializeWhitelistPropertyMap()
    this.config = {}
  }

  intializeEnvOptions(envOptions) {
    const defaultEnvVars = {
      bearerToken: "MESHBLU_BEARER_TOKEN",
      uuid: "MESHBLU_UUID",
      token: "MESHBLU_TOKEN",
      protocol: "MESHBLU_PROTOCOL",
      hostname: "MESHBLU_HOSTNAME",
      port: "MESHBLU_PORT",
      service: "MESHBLU_SERVICE",
      domain: "MESHBLU_DOMAIN",
      secure: "MESHBLU_SECURE",
      privateKey: "MESHBLU_PRIVATE_KEY",
      resolveSrv: "MESHBLU_RESOLVE_SRV",
      serviceName: "MESHBLU_SERVICE_NAME",
    }

    this.envOptions = _.defaults(envOptions, defaultEnvVars)
  }

  initializeWhitelistPropertyMap() {
    this.whitelistedPropertyMap = {
      bearerToken: {
        env: this.envOptions.bearerToken,
      },
      domain: {
        env: this.envOptions.domain,
      },
      hostname: {
        env: this.envOptions.hostname,
      },
      port: {
        env: this.envOptions.port,
      },
      privateKey: {
        env: this.envOptions.privateKey,
      },
      protocol: {
        env: this.envOptions.protocol,
      },
      resolveSrv: {
        env: this.envOptions.resolveSrv,
        validator: Validators.bool(),
      },
      secure: {
        env: this.envOptions.secure,
        validator: Validators.bool(),
      },
      service: {
        env: this.envOptions.service,
      },
      serviceName: {
        env: this.envOptions.serviceName,
      },
      token: {
        env: this.envOptions.token,
      },
      uuid: {
        env: this.envOptions.uuid,
      },
    }
  }

  addConfig(data) {
    data = data || {}
    data = _.pick(data, _.keys(this.whitelistedPropertyMap))
    const validatorMap = this.getValidatorMap()
    _.each(validatorMap, (validator, key) => {
      data[key] = validator(data[key])
    })
    this.config = _.defaults(data, this.config)
  }

  getValidatorMap() {
    const validatorMap = {}
    _.each(this.whitelistedPropertyMap, (value, key) => {
      const { validator } = value
      if (!validator) return
      validatorMap[key] = validator
    })
    return validatorMap
  }

  getEnvMap() {
    const envMap = {}
    _.each(this.whitelistedPropertyMap, (value, key) => {
      const { env } = value
      if (!env) return
      envMap[env] = key
    })
    return envMap
  }

  processEnv(env) {
    const data = {}
    const envMap = this.getEnvMap()
    _.each(envMap, (value, key) => {
      data[value] = env[key]
    })
    return data
  }

  loadFile(filename) {
    filename = filename || this.defaultFilename
    const data = fs.readJsonSync(filename)
    this.addConfig(data)
  }

  loadEnv(env) {
    env = env || this.env
    const data = this.processEnv(env)
    this.addConfig(data)
  }

  loadData(data) {
    this.addConfig(data)
  }

  get() {
    return _.clone(this.config)
  }

  generate(data) {
    data = _.clone(data || {})
    console.log(this.defaultFilename, fs.existsSync(this.defaultFilename))
    if (fs.existsSync(this.defaultFilename)) this.loadFile(this.defaultFilename)
    this.loadEnv()
    this.loadData(data)
    return this.get()
  }
}

module.exports = MeshbluConfig

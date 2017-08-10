{describe,beforeEach,it,expect} = global
path          = require 'path'
MeshbluConfig = require '..'

describe 'MeshbluConfig', ->
  describe 'passing in a uuid/token the old way', ->
    it 'should throw an exception', ->
      construction = => new MeshbluConfig uuid: 'an-uuid', token: 'a-token'
      expect(construction).to.throw 'MeshbluConfig no longer accepts legacy parameters in the constructor, see documentation'

  describe 'from a file', ->
    describe 'passing in a filename', ->
      beforeEach ->
        @sut = new MeshbluConfig
        @sut.loadFile path.join(__dirname, 'sample-meshblu.json')
        @result = @sut.get()

      it 'should set the hostname', ->
        expect(@result.hostname).to.deep.equal 'localhost'

      it 'should set the port', ->
        expect(@result.port).to.deep.equal '3000'

    describe 'passing in a file with no protocol', ->
      beforeEach ->
        @sut = new MeshbluConfig
        @sut.loadFile path.join(__dirname, 'no-protocol-meshblu.json')
        @result = @sut.get()

      it 'should not set the protocol', ->
        expect(@result.hostname).to.exist
        expect(@result.protocol).not.to.exist
        expect(@result).not.to.have.key 'protocol'

  describe 'from env', ->
    describe 'passing in env', ->
      beforeEach ->
        env =
          MESHBLU_BEARER_TOKEN: 'bearer-token'
          MESHBLU_UUID: 'the-uuid'
          MESHBLU_TOKEN: 'the-token'
          MESHBLU_PROTOCOL: 'https'
          MESHBLU_HOSTNAME: 'my-hostname'
          MESHBLU_PORT: 'a-port'
          MESHBLU_SERVICE: 'the-service'
          MESHBLU_DOMAIN: 'your-domain'
          MESHBLU_SECURE: 'true'
          MESHBLU_PRIVATE_KEY: 'a-private-key'
          MESHBLU_RESOLVE_SRV: "true"
          MESHBLU_SERVICE_NAME: "the-service-name"
        @sut = new MeshbluConfig
        @sut.loadEnv(env)
        @result = @sut.get()

      it 'should set the resolveSrv', ->
        expectedResult =
          bearerToken: 'bearer-token'
          domain: 'your-domain'
          hostname: 'my-hostname'
          port: 'a-port'
          privateKey: 'a-private-key'
          protocol: 'https'
          resolveSrv: true
          secure: true
          service: 'the-service'
          serviceName: 'the-service-name'
          token: 'the-token'
          uuid: 'the-uuid'

        expect(@result).to.deep.equal expectedResult

    describe 'override envOptions', ->
      beforeEach ->
        envOptions =
          bearerToken: 'OTHER_BEARER_TOKEN'
          uuid: 'OTHER_UUID'
          token: 'OTHER_TOKEN'
          protocol: 'OTHER_PROTOCOL'
          hostname: 'OTHER_HOSTNAME'
          port: 'OTHER_PORT'
          service: 'OTHER_SERVICE'
          domain: 'OTHER_DOMAIN'
          secure: 'OTHER_SECURE'
          privateKey: 'OTHER_PRIVATE_KEY'
          resolveSrv: 'OTHER_RESOLVE_SRV'
          serviceName: 'OTHER_SERVICE_NAME'
        env =
          OTHER_BEARER_TOKEN: 'bearer-token'
          OTHER_UUID: 'the-uuid'
          OTHER_TOKEN: 'the-token'
          OTHER_PROTOCOL: 'https'
          OTHER_HOSTNAME: 'my-hostname'
          OTHER_PORT: 'a-port'
          OTHER_SERVICE: 'the-service'
          OTHER_DOMAIN: 'your-domain'
          OTHER_SECURE: 'true'
          OTHER_PRIVATE_KEY: 'a-private-key'
          OTHER_RESOLVE_SRV: "true"
          OTHER_SERVICE_NAME: "the-service-name"
        @sut = new MeshbluConfig { envOptions }
        @sut.loadEnv(env)
        @result = @sut.get()

      it 'should set the resolveSrv', ->
        expectedResult =
          bearerToken: 'bearer-token'
          domain: 'your-domain'
          hostname: 'my-hostname'
          port: 'a-port'
          privateKey: 'a-private-key'
          protocol: 'https'
          resolveSrv: true
          secure: true
          service: 'the-service'
          serviceName: 'the-service-name'
          token: 'the-token'
          uuid: 'the-uuid'

        expect(@result).to.deep.equal expectedResult

  describe 'from data', ->
    describe 'passing in all possible data', ->
      beforeEach ->
        data =
          bearerToken: 'bearer-token'
          domain: 'your-domain',
          hostname: 'my-hostname',
          port: 'a-port',
          privateKey: 'a-private-key',
          protocol: 'https',
          resolveSrv: true,
          secure: 'true',
          service: 'the-service',
          serviceName: 'the-service-name',
          token: 'the-token',
          uuid: 'the-uuid',

        @sut = new MeshbluConfig
        @sut.loadData(data)
        @result = @sut.get()

      it 'should set the resolveSrv', ->
        expectedResult =
          bearerToken: 'bearer-token'
          domain: 'your-domain',
          hostname: 'my-hostname',
          port: 'a-port',
          privateKey: 'a-private-key',
          protocol: 'https',
          resolveSrv: true,
          secure: true,
          service: 'the-service',
          serviceName: 'the-service-name',
          token: 'the-token',
          uuid: 'the-uuid',
        expect(@result).to.deep.equal expectedResult

  describe 'generate', ->
    describe 'from all sources', ->
      beforeEach ->
        data = uuid: 'the-uuid'
        env = MESHBLU_SERVICE_NAME: 'service-name', MESHBLU_RESOLVE_SRV: "true"
        filename = path.join(__dirname, 'sample-meshblu.json')
        @sut = new MeshbluConfig { env, defaultFilename: filename }
        @result = @sut.generate(data)

      it 'should set all the stuff', ->
        expect(@result.uuid).to.equal 'the-uuid'
        expect(@result.resolveSrv).to.be.true
        expect(@result.serviceName).to.equal 'service-name'
        expect(@result.hostname).to.equal 'localhost'

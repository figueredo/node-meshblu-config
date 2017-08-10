class Validators {
  static bool() {
    return function(input) {
      switch (input) {
        case true:
        case "true":
        case "t":
        case "1":
          return true
        case false:
        case "false":
        case "f":
        case "0":
          return false
        default:
          return null
      }
    }
  }
}

module.exports = Validators

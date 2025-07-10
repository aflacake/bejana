# errors.rb

class BejanaError < StandardError; end
class ValidationError < BejanaError; end
class ExecutionError < BejanaError; end

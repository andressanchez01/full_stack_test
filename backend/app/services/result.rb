class Result
    attr_reader :value, :error
  
    def initialize(success, value, error = nil)
      @success = success
      @value = value
      @error = error
    end
  
    def self.success(value)
      Result.new(true, value)
    end
  
    def self.failure(error)
      Result.new(false, nil, error)
    end
  
    def success?
      @success
    end
  
    def failure?
      !@success
    end
  
    def then
      return self if failure?
      yield(value)
    end
end
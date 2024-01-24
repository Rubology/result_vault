# frozen_string_literal: true

require_relative "result_vault/version"

##
# A mechanism for returning a multi-factor result from any object call.
#
# @example
#   result = ResultVault.new(error_message: "missing user", user_id: 123)
#   result.user_name = 'Test User'
#
#   result.user_id        #=> 123
#   result.user_name      #=> 'Test User'
#   result.error_message  #=> "missing user"
#
class ResultVault

  # ======================================================================
  # = Public Methods
  # ======================================================================

  ##
  # Returns the success value
  #
  # @return [boolean] success
  #
  def success?
    !!@success
  end
  alias :ok?        :success?
  alias :good?      :success?
  alias :pass?      :success?
  alias :passed?    :success?
  alias :succeeded? :success?


  ##
  # Set success to true
  #
  def success=(val)
    _update_vault(:success, val)
  end
  alias :ok=        :success=
  alias :good=      :success=
  alias :pass=      :success=
  alias :passed=    :success=
  alias :succeeded= :success=


  ##
  # Resturns the status or nil
  #
  # @return [Symbol, String, *, nil]
  #
  def status
    @status
  end


  ##
  # Sets the status
  #
  # @param [*] new_status
  #   a description of the error
  #
  def status=(new_status)
    _update_vault(:status, new_status)
  end


  ##
  # Returns the stored exception
  #
  # @returns [Exception, nil]
  #
  def exception
    @exception
  end


  ##
  # Sets the stored exception
  #
  # @param [Exception] xcptn
  #   an instance of the Exception class
  #
  def exception=(xcptn)
    _update_vault(:exception, xcptn)
  end


  ##
  # Resturns the stored error message or an empty string
  #
  # @return [String]
  #
  def error_message
    @error_message
  end


  ##
  # Sets the error message
  #
  # @param [String] err_msg
  #   a description of the error
  #
  def error_message=(err_msg)
    _update_vault(:error_message, err_msg)
  end


  ##
  # Raise an exception if the user is setting data directly
  #
  def data=(*)
    fail ArgumentError, ":data is a reserved keyword and may not be set directly."
  end


  ##
  # Return a frozen copy of the stoted data
  #
  # @returns [Hash]
  #
  def data
    result                  = @data.dup
    result[:success]        = success?
    result[:status]         = status
    result[:error_message]  = error_message
    result.freeze
  end


  ##
  # Return an array of method names
  #
  # @retun [Array[Symbol]]
  #
  def methods(regular = true)
    method_names  = super(regular)
    method_names += _data_method_names
    method_names -= _excluded_method_names

    return method_names
  end


  ##
  # Returns true if the vaul responds to the given methods
  #
  # @param [Symbol, String]
  def respond_to?(name)
    return false if _excluded_method_names.include?(name.to_sym)
    return true  if _data_method_names.include?(name.to_sym)
    super
  end


  # ======================================================================
  # = Private
  # ======================================================================
  #
  private

  ##
  # Initialize the response object's data-hash with the given arguments
  #
  # @param [Hash] args
  #   a list of keyword parameters
  #
  def initialize(**args)
    @data           = {}
    @success        = false
    @exception      = nil
    @error_message  = ''

    # add all arguments to the data hash
    args.each { |key, val| _update_vault(key, val) }
  end


  ##
  # Update the Vault's data
  #
  # @param [Symbol] key
  #   the key to use for storage
  #
  # @param [*]
  #   the value to be stored
  #
  def _update_vault(key, val)
    _assert_symbolic_key(key)
    _assert_not_frozen!

    case key
    when :data
      fail ArgumentError, ":data is a reserved keyword and may not be set directly."

    when :status
      @status = val

    when :exception
      _assert_valid_exception(val)
      @exception = val

    when :success, :ok, :good, :pass, :passed, :succeeded
      @success = !!val

    when :error_message
      @error_message = val

    else
      @data[key] = val
    end
  end


  ##
  # Return an array of the method names that should be excluded
  # from the list of available methods.
  #
  # @note
  #   This changes on whether the vault is frozen or not
  #
  def _excluded_method_names
    excluded = [:data=]

    if frozen?
      excluded += [:success=, :ok=, :good=, :pass=, :succeeded=, :status=, :exception=, :error_messgae=]

      @data.keys.each { |key| excluded << "#{key}=".to_sym }
    end

    return excluded
  end


  ##
  # Return an array of the data keys for this vault,
  # omitting the setter methods if the vault is frozen
  #
  def _data_method_names
    data_methods = []

    @data.keys.each do |key|
      data_methods << key
      data_methods << "#{key}=".to_sym unless frozen?
    end

    return data_methods
  end


  ##
  # Test if an ancestor class has the method, otherwise test if
  # it's a vault dynamic method
  #
  # @param [Symbol] method_sym
  #   the name of the method
  #
  # @param [Array] arguments
  #   the arguments for the method
  #
  # @block
  #   an optional block
  #
  def method_missing(method_sym, *arguments, &block)
    no_method_error = nil
    catch :check_ancestors do
      super
    rescue => e
      no_method_error = e
      throw :check_ancestors
    end

    _dynamic_method_missing(method_sym, arguments.first, no_method_error)
  end


  ##
  # If the missing method name ends in an '=' character, update the data.
  # If the missing method name is already within the data hash, return the value
  #
  # @param [Symbol] method_sym
  #   the name of the method
  #
  # @param * the value to set
  #   the value for setting the method
  #
  # @param [NoMethodError]
  #   the no methed exection to raise if there's no dynamic method
  #
  def _dynamic_method_missing(method_sym, val, no_method_error)
    case
    when @data.keys.include?(method_sym)
      @data[method_sym]

    when method_sym[-1].eql?('=')
      _update_vault(method_sym[0..-2].to_sym, val)

    else
      raise no_method_error
    end
  end


  ##
  # @return [boolean]
  #   true if the given method end with an '=' or the method exists
  #
  def respond_to_missing?(method_sym, include_private = false)
    return true  if super
    return true  if @data.keys.include?(method_sym)
    return false if frozen?

    method_sym[-1].eql?('=')
  end


  # = Assertions
  # ======================================================================

  ##
  # Raise an exception if the provided key is not a Symbol
  #
  def _assert_symbolic_key(key)
    return if key.is_a?(Symbol)
    fail ArgumentError, "String key submitted: '#{key}'. Keys should be Symbols only."
  end


  ##
  # Raise an error if the result is forzen
  #
  # @raise [RuntimeError]
  #   if the result is frozen
  #
  def _assert_not_frozen!
    fail 'This result vault may no longer be modified' if frozen?
  end


  ##
  # Raise an exception if the provided value is not an Expection
  #
  def _assert_valid_exception(exception)
    return if exception.is_a?(Exception)
    fail ArgumentError, "The :exception= method will only accept an Exception instance, such as RuntimeError or AurgumentError"
  end

end

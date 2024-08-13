
[//]: # "###################################################"
[//]: # "#####                 HEADER                  #####"
[//]: # "###################################################"


# [ResultVault](https://github.com/Rubology/result_vault)



[//]: # "############################################"
[//]: # "#####             BADGES               #####"
[//]: # "############################################"


| Main Branch| Dev Branch|
|---|---|
| ![ruby 3.3](https://github.com/Rubology/result_vault/actions/workflows/ruby_3_3.yml/badge.svg?branch=main) | ![ruby 3.3](https://github.com/Rubology/result_vault/actions/workflows/ruby_3_3.yml/badge.svg?branch=dev) |
| ![ruby 3.2](https://github.com/Rubology/result_vault/actions/workflows/ruby_3_2.yml/badge.svg?branch=main) | ![ruby 3.2](https://github.com/Rubology/result_vault/actions/workflows/ruby_3_2.yml/badge.svg?branch=dev) |
| ![ruby 3.1](https://github.com/Rubology/result_vault/actions/workflows/ruby_3_1.yml/badge.svg?branch=main) | ![ruby 3.1](https://github.com/Rubology/result_vault/actions/workflows/ruby_3_1.yml/badge.svg?branch=dev) |
| ![ruby 3.0](https://github.com/Rubology/result_vault/actions/workflows/ruby_3_0.yml/badge.svg?branch=main)  | ![ruby 3.0](https://github.com/Rubology/result_vault/actions/workflows/ruby_3_0.yml/badge.svg?branch=dev)  |
| ![ruby 2.7](https://github.com/Rubology/result_vault/actions/workflows/ruby_2_7.yml/badge.svg?branch=main) | ![ruby 2.7](https://github.com/Rubology/result_vault/actions/workflows/ruby_2_7.yml/badge.svg?branch=dev) |
| &nbsp; |  |
| [![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](#license)  | [![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](#license) |
| [![Gem Version](https://badge.fury.io/rb/result_vault.svg)](https://badge.fury.io/rb/result_vault) | [![Gem Version](https://badge.fury.io/rb/result_vault.svg)](https://badge.fury.io/rb/result_vault) |
| ![100% Coverage](https://github.com/Rubology/result_vault/actions/workflows/code_coverage.yml/badge.svg?branch=main) | ![100% Coverage](https://github.com/Rubology/result_vault/actions/workflows/code_coverage.yml/badge.svg?branch=dev) |



[//]: # "###################################################"
[//]: # "#####                  INDEX                  #####"
[//]: # "###################################################"


## Index

- [description](#description)
- [requirements](#requirements)
- [installation](#installation)
- [usage](#usage)
- [special methods](#special_methods)
    - [:success? (:ok?, :good?, :pass?, :passed?, :succeeded?)](#success)
    - [:status](#status)
    - [:exception](#exception)
    - [:error_message](#error_message)
    - [:data](#data)
    - [:update](#update)
- [freezing results](#freezing)
- [change log](CHANGELOG.md)
- [code of conduct](#code-of-conduct)
- [license](#license)


---


[//]: # "###################################################"
[//]: # "#####               DESCRIPTION               #####"
[//]: # "###################################################"


<a name='description'></a>
## Description

> Returning multiple details from a single method call.

Methods that represent domain logic or complex calculations frequently need to
report back multiple details in the result.

For example: a method to authenticate a user with an email and password may need
to respond that the given credentials were good, but the user's account
is currenly suspended.

**ResultVault** encapsulates this information in a way that the caller can easily
access it.

> Why not an Array or Hash?

An Array requires the caller to know exactly which data is in which
position. This is too tighly coupled and doesn't allow for a variable number of data.

A Hash is much better, but it requires an agreed policy on it's usage: 
- Strings or Symbols for the key?
- which key represents a successful outcome?
- which key reports an error?

**ResultVault** simplifies this process by providing a simple structure using method 
calls to set and return the data.

```ruby
result = ResultVault.new
result.success = true
result.max_value = 976
result.user_name = 'Test User'

result.success?  #=> true
result.max_value #=> 976
result.user_name #=> 'Test User'
```



---

[//]: # "###################################################"
[//]: # "#####               REQUIREMENTS              #####"
[//]: # "###################################################"


<a name='requirements'></a>
## Requirements

- Ruby 2.7+



---

[//]: # "###################################################"
[//]: # "#####              INSTALLATION               #####"
[//]: # "###################################################"


<a name='installation'></a>
## Installation

Add this line to your Gemfile:

`gem 'result_vault'`



---

[//]: # "#################################"
[//]: # "#####         HOW TO        #####"
[//]: # "#################################"


<a name='usage'></a>
## Usage

1. decide what data you want to add: '_user_name_'
2. create a new **ResultVault**: `result = ResultVault.new`
3. add the data to the result: `result.user_name = 'Test User'`
4. read the data back from the result: `result.user_name #=> 'Test User'`

> **Note:** <br/> Data can be set on creation: `ResultVault.new(user_name: 'Test User')`

In this example a call to `:average` retuns the total, size and average of an Array of Integers:

```ruby
def average(nums)
    result         = ResultVault.new
    result.total   = nums.sum
    result.size    = nums.size
    result.average = result.total / result.size
    result.success = true
    return result
end

num_array = [1,2,3,4,5]
result    = average(num_array)
result.success? #=> true
result.average  #=> 3
result.total    #=> 15
result.size     #=> 5
```

### dynamic getters & setters:

Calling a method without first setting the data will raise a `NoMethodError`.

```ruby
result = ResultVault.new

result.user_name  #=> NoMethodErrror
result.user_name = 'Test User'
result.user_name  #=> 'Test User'
```

> **Note:** <br/> Internally, **ResultVault** does **not** create dynamic getters & setters, so the method look-up chain remains unchanged & performant.

---

[//]: # "####################################"
[//]: # "#####      SPECIAL METHODS     #####"
[//]: # "####################################"


<a name='special_methods'></a>
## Special Methods

- [:success? (:ok?, :good?, :pass?, :passed?, :succeeded?)](#success)
- [:status](#status)
- [:exception](#exception)
- [:error_message](#error_message)
- [:data](#data)
- [:update](#update)


There are five methods pre-defined to help developers easily determine
success or failue, what went wrong, what's the current status & to
inspect the vault contents.

> Having these methods pre-defined provides a base structure for developers, improving familiarity.


<a name='success'></a>
### :success?

If the method ran successfully then `:success` should be set to `true`, 
otherwise it will default to `false`.

```ruby
result = ResultVault.new
result.success? #=> false
result.success = true
result.success? #=> true
```

To make it more sematically correct to query a result within a specific context, 
`:success?` has been aliased with:

- `:ok?`
- `:good?`
- `:pass?`
- `:passed?`
- `:succeeded?`

> The same aliases can also be used to set the value of success: `result.passed = true`


<a name='status'></a>
### :status

Often a method will complete without any errors, but the outcome
may not be perfect. The `:status` method helps clear this up.

For example, an `:authenticate_user(email, pwd)` might successfully
authenticate the user (so the email and password are correct), but
the user's account may be suspended, so they're not allowed access.

This could be reported by setting `result.success = true` and `result.status = :suspended`.
The controller would then know not to re-render the form but to dispay an 'Account Suspended'
message.


<a name='exception'></a>
### :exception

If the method fails with an exception, rather than having the caller catch it, the 
method should rescue the exception and add it to the result returned to the caller.
The caller would then know the method failed and could interrogate why.


```ruby
def failing_method
   result = ResultVault.new
   1/0
rescue => e
   result.exception = e
ensure
   return result
end

result = failing_method
result.success?            #=> false
result.error_message       #=> "divided by 0"
result.exception           #=> #<ZeroDivisionError: divided by 0>
result.exception.backtrace #=> [..........]
```
> **Note:** <br/>`:error_message` is set automatically if not previously set.

<a name='error_message'></a>
### :error_message


The `:error_message` allows for a readable error message, and can be
used even when there is no exeption recorded.

```ruby
def test_method
   result = ResultVault.new
   result.error_message = "Test message"
   return result
end

result = test_method
result.error_message    #=> "Test message"
```


<a name='data'></a>
### :data

`:data` returns a frozen Hash of the vaults data:

```ruby
def average(nums)
    result = ResultVault.new
    result.total   = nums.sum
    result.size    = nums.size
    result.average = nums.sum / nums.size
    result.success = true
    return result
end

num_array = [1,2,3,4,5]
result    = average(num_array)
result.data #=> {:total=>15, :size=>5, :average=>3, :success=>true, :status=>nil, :error_message=>""}
```

> **Note:** <br/>Use `:update` to add or update data.



<a name='update'></a>
### :update

`:update` sets new or updates existing data values:

```ruby
result = ResultVault.new(age: 9.75)
result.success? #=> false
result.age      #=> 9.75
result.name     #=> Undefined method `name'

result.update(success: true, age: 23, name: 'Tester')

result.success? #=> true
result.age      #=> 23
result.name     #=> 'Tester'
end

num_array = [1,2,3,4,5]
result    = average(num_array)
result.data #=> {:total=>15, :size=>5, :average=>3, :success=>true, :status=>nil, :error_message=>""}
```

---

[//]: # "################################"
[//]: # "#####       FREEZING       #####"
[//]: # "################################"


<a name='freezing'></a>
## Freezing Results

We strongly recommend freezing the result before returning
it to the caller. Doing this prohibits the caller from
accidentaly modifying any of the result data or adding new information.

```ruby
def tester
    result = ResultVault.new
    result.user_name = 'Test User'
    return result.freeze
end

result = tester
result.user_name  #=> 'Test User'
result.user_name = "My Name" #=> This result vault may no longer be modified (RuntimeError)
result.new_data  = "My Name" #=> This result vault may no longer be modified (RuntimeError)
```

---

[//]: # "####################################"
[//]: # "#####       CONTRIBUTING       #####"
[//]: # "####################################"


<a name='contributing'></a>
## Contributing

> - [Security issues](#security-issues)
> - [Reporting issues](#reporting-issues)
> - [Pull requests](#pull-requests)

In all cases please respect our [Contributor Code of Conduct](#code-of-conduct).


<a name='security-issues'></a>
### Security issues

If you have found a security related issue, please follow our 
[Security Policy](SECURITY.md).


<a name='reporting-issues'></a>
### Reporting issues

Please try to answer the following questions in your bug report:

- What did you do?
- What did you expect to happen?
- What happened instead?

Make sure to include as much relevant information as possible, including:

- ResultVault version.
- Ruby version.
- OS version.
- The steps needed to replicate the issue.
- Any stack traces you have are very valuable.


<a name='pull-requests'></a>
### Pull Requests

We encourage contributions via GitHub pull requests.


---

[//]: # "###################################################"
[//]: # "#####              CODE OF CONDUCT            #####"
[//]: # "###################################################"


<a name='code-of-conduct'></a>
## Code of Conduct

We as members, contributors, and leaders pledge to make participation in our
community a harassment-free experience for everyone, regardless of age, body
size, visible or invisible disability, ethnicity, sex characteristics, gender
identity and expression, level of experience, education, socio-economic status,
nationality, personal appearance, race, religion, or sexual identity 
and orientation.


Read the full details in our [Contributor Code of Conduct](CODE_OF_CONDUCT.md).



---

[//]: # "###################################################"
[//]: # "#####                  LICENSE                #####"
[//]: # "###################################################"


<a name='license'></a>
## License

The MIT License (MIT)

Copyright (c) 2024 CodeMeister

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.



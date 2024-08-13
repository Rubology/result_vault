# CHANGELOG

## 1.4.0
- New method `:update` added.
  - The :update method accepts data to be added in the format `key: value`.
  - New data is created and existing data is updated.
  - E.g. `result.update( success: true, name: 'Tester', time: Time.now )`

## 1.3.0
- When recording an exception: 
  - Unless perviously defined, the :error_message attribute is automatically set with the exception's error message.


## 1.2.3
- Initial public release


observable class DataSensors
  constructor: (conf) ->
    @init
      events: ['change']

    @room_name = conf.room_name

    @poll()

  poll: () ->
    d3.json "data/smart_building/weboffice/get_services.php?room_name="+@room_name, (data) =>
      @data_sensor = data

      @trigger 'change'

  get_data_sensor: () -> @data_sensor

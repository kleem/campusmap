observable class RoomSensors
  constructor: (conf) ->
    @init
      events: ['change']

    @room_name = conf.room_name

    @poll()

  poll: () ->
    d3.json "data/smart_building/weboffice/get_sensors.php?room_name="+@room_name, (data) =>
      @sensors = data

      @trigger 'change'

  get_sensors: () -> @sensors

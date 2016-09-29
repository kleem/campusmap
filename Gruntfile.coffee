module.exports = (grunt) ->
  grunt.initConfig
    concat:
      dist:
        src: ['lib/d3.v4.min.js', 'lib/d3-selection-multi.v0.4.min.js']
        dest: 'lib/libs.js'
    coffee:
      compile:
        options:
          join: true
          sourceMap: true
        files:
          'app.js':
            [
              '*/*.coffee'
              'index.coffee'
            ]
    watch:
      files: [
        'index.coffee',
        '*/*.coffee'
      ]
      tasks:
        [
          'coffee',
          'concat'
        ]

  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['coffee', 'concat']

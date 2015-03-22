'use strict'

Range = (ace.require 'ace/range').Range

app = angular.module 'Assembler', []

app.controller 'AssemblerController', ['$scope', '$http', ($scope, $http) ->
  { initContext, draw, setVideoData } = Chip8Renderer()

  initContext document.getElementById 'can'

  TICKS_PER_FRAME = 1

  rafId = null

  editor = null
  errorLine = null

  lineMapping = null
  marker = null

  @status = 'idle'

  @emulatorState = null

  assembler = Chip8Assembler()

  keyboard = Chip8Keyboard()
  (document.getElementById 'container').appendChild keyboard.getHtml()

  chip8 = Chip8()
  chip8.setKeyboard keyboard


  onChange = (text) ->
    clearMarker()
    if text.length == 0
      editor.getSession().setAnnotations []
    else
      try
        assembler.assemble text
        if errorLine != null
          editor.getSession().setAnnotations []
          errorLine = null
      catch ex
        if ex.coords?
          errorLine = ex.coords.line
          editor.getSession().setAnnotations([
            row: errorLine
            text: ex.message
            type: 'error'
          ])

    return


  setupEditor = ->
    editor = ace.edit 'editor'
    editor.getSession().setMode 'ace/mode/chip8'
    editor.setTheme 'ace/theme/monokai'
    editor.on 'input', -> onChange editor.getValue()
    return


  setupEditor()


  getEmulatorState = ->
    programCounter = chip8.getProgramCounter()
    stackPointer = chip8.getStackPointer()
    I = chip8.getI()
    registers = Array::slice.call chip8.getRegisters(), 0
    stack = Array::slice.call chip8.getStack(), stackPointer

    {
      programCounter
      registers
      stackPointer
      I
      stack
    }


  loadSample = (sampleName) ->
    $http.get "samples/#{sampleName}.chip8", { responseType: 'text' }
    .success (source) =>
      editor.setValue source, -1


  loadSample 'sprites'


  clearMarker = ->
    editor.getSession().removeMarker marker if marker?
    marker = null
    return


  @clearMarker = clearMarker


  @updateMarker = ->
    @clearMarker()
    if lineMapping?
      line = lineMapping.get @emulatorState.programCounter
      if line?
        range = new Range line, 0, line, 100
        marker = editor.getSession().addMarker range, 'active-line', 'fullLine'
    return


  @updateVideo = ->
    setVideoData chip8.getVideo()
    draw()


  @updateEmulatorState = ->
    @emulatorState = getEmulatorState()


  @startMainLoop = ->
    return if rafId?

    mainLoop = =>
      for i in [0...TICKS_PER_FRAME]
        chip8.tick()

      @updateEmulatorState()
      $scope.$apply() unless $scope.$$phase

      @updateVideo()

      rafId = requestAnimationFrame mainLoop
      return

    mainLoop()
    return


  @stopMainLoop = ->
    cancelAnimationFrame rafId
    rafId = null
    return


  @start = ->
    @reset() if @status == 'idle'
    @status = 'running'
    @clearMarker()
    @startMainLoop()
    return


  @pause = ->
    @status = 'paused'
    @stopMainLoop()
    @updateMarker()
    return


  @stop = ->
    @status = 'idle'
    @stopMainLoop()
    return


  @reset = ->
    @stop()

    text = editor.getValue()
    if text.length
      try
        { instructions, lineMapping } = assembler.assemble text
        chip8.load instructions
      catch ex

    chip8.reset()
    @updateEmulatorState()
    @updateVideo()
    @updateMarker()
    return


  @reset()


  @step = ->
    @reset() if @status == 'idle'
    @status = 'paused'
    chip8.tick()
    @updateEmulatorState()
    @updateVideo()
    @updateMarker()
    return


  return
]
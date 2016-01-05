// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  var app;

  app = angular.module('Disassembler', []);

  app.controller('DisassemblerController', [
    '$scope', '$http', function($scope, $http) {
      var disassemble, editor, serialize, setupEditor, _ref;
      _ref = Chip8Disassembler(), disassemble = _ref.disassemble, serialize = _ref.serialize;
      this.selectedRomName = 'MAZE';
      this.romNames = ['15PUZZLE', 'BLINKY', 'BLITZ', 'BRIX', 'CONNECT4', 'GUESS', 'HIDDEN', 'INVADERS', 'KALEID', 'MAZE', 'MERLIN', 'MISSILE', 'PONG', 'PONG2', 'PUZZLE', 'SYZYGY', 'TANK', 'TETRIS', 'TICTAC', 'UFO', 'VBRIX', 'VERS', 'WIPEOFF', 'ZERO'];
      editor = null;
      setupEditor = function() {
        editor = ace.edit('editor');
        editor.getSession().setMode('ace/mode/chip8');
        editor.setTheme('ace/theme/monokai');
      };
      setupEditor();
      this.changeRom = function() {
        return $http.get("../../roms/" + this.selectedRomName, {
          responseType: 'arraybuffer'
        }).success(function(data) {
          var instructions, jumpAddresses, str, _ref1;
          _ref1 = disassemble(new Uint8Array(data), 0x0200), instructions = _ref1.instructions, jumpAddresses = _ref1.jumpAddresses;
          str = serialize(instructions, jumpAddresses, 0x0200);
          editor.setValue(str, -1);
        });
      };
      this.changeRom();
    }
  ]);

}).call(this);
##Assembler

| Chip8 instruction | Assembler instruction |
| ----------------- | --------------------- |
| 0NNN              | -                     |
| 00E0              | cls                   |
| 00EE              | return                |
| 1NNN              | jump                  |
| 2NNN              | call                  |
| 3XNN              | sei                   |
| 4XNN              | snei                  |
| 5XY0              | ser                   |
| 6XNN              | movi                  |
| 7XNN              | addi                  |
| 8XY0              | movr                  |
| 8XY1              | or                    |
| 8XY2              | and                   |
| 8XY3              | xor                   |
| 8XY4              | addr                  |
| 8XY5              | subr                  |
| 8XY6              | shr                   |
| 8XY7              | nsubr                 |
| 8XYE              | shl                   |
| 9XY0              | sner                  |
| ANNN              | imovi                 |
| BNNN              | jumpoff               |
| CXNN              | rnd                   |
| DXYN              | sprite                |
| EX9E              | skr                   |
| EXA1              | snkr                  |
| FX07              | rmovt                 |
| FX0A              | waitk                 |
| FX15              | movt                  |
| FX18              | movs                  |
| FX1E              | iaddr                 |
| FX29              | digit                 |
| FX33              | bcd                   |
| FX55              | store                 |
| FX65              | load                  |
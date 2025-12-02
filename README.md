Associate Final Project — Electronic 6-Digit Security Lock (ATmega16L)

Overview

This project implements a 6-digit electronic security lock using an ATmega16L microcontroller.
The system includes a keypad interface, LCD feedback, EEPROM-based password storage, a relay driver for door control, and an alarm mechanism after three failed attempts.
The firmware was written entirely in C, emphasizing embedded logic, secure input handling and hardware–software integration.

Key Features & My Contributions

- Designed and implemented the full firmware: keypad scanning, LCD UI, debounce handling, password logic, EEPROM persistence and lockout policies.

- Built and tested the full hardware schematic: keypad matrix, 2×16 LCD, buzzer, relay driver (with protection), power stage.

- Verified I/O timing, pull-up design, and MCU pin-mapping on physical hardware.

- Documented hardware–software integration and system behavior for academic evaluation.


Technologies Used

   C (low-level embedded programming)

   ATmega16L microcontroller (AVR)

   EEPROM password storage

   Digital I/O drivers, LCD interface, keypad matrix scanning

   Hardware debugging & embedded system testing

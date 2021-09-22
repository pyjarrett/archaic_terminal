with Ada.Characters.Latin_1;

-- Platform agnostic VT100 commands.
--
-- ECMA-48 (ISO 6429)
-- C0 (7-bit) control codes
-- C1 (8-bit) control codes
-- CSI = Control Sequence Introducer
-- https://vt100.net/
-- https://vt100.net/docs/vt510-rm/chapter4.html
-- https://en.wiktionary.org/wiki/Appendix:Control_characters
-- https://mudhalla.net/tintin/info/vt100/
-- https://www.aivosto.com/articles/control-characters.html
-- https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
-- https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences
package Trendy_Terminal.VT100 is
    CSI : constant String := Ada.Characters.Latin_1.ESC & "[";

    procedure Cursor_Left;
    procedure Cursor_Right;
    procedure Cursor_Down;
    procedure Cursor_Up;

    procedure Scroll_Down;
    procedure Scroll_Up;

    procedure Cursor_Next_Line;

    procedure Erase;

    procedure Beginning_Of_Line;
    procedure Clear_Line;

    procedure Report_Cursor_Position;

    procedure Set_Cursor_Position (C : Cursor_Position);

end Trendy_Terminal.VT100;

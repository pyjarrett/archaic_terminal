-------------------------------------------------------------------------------
-- Copyright 2021, The Trendy Terminal Developers (see AUTHORS file)

-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--     http://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-------------------------------------------------------------------------------

with Interfaces.C.Strings;
with System;

package Trendy_Terminal.Linux is

    ---------------------------------------------------------------------------
    -- Interfacing with C
    ---------------------------------------------------------------------------
    -- Crash course in how this works.
    -- https://en.wikibooks.org/wiki/Ada_Programming/Types/access#Access_vs._System.Address
    type BOOL is new Interfaces.C.int;
    type FD is new Interfaces.C.int;
    type FILE_Ptr is new System.Address;

    function fileno (Stream : FILE_Ptr) return FD with
        Import     => True,
        Convention => C;

    function isatty (File_Descriptor : FD) return BOOL with
        Import     => True,
        Convention => C;

    stdin  : aliased FILE_Ptr;
    stdout : aliased FILE_Ptr;
    stderr : aliased FILE_Ptr;

    pragma Import (C, stdin, "stdin");
    pragma Import (C, stdout, "stdout");
    pragma Import (C, stderr, "stderr");

    NCCS : constant := 32;
    type tcflag_t is new Interfaces.C.unsigned;
    type cc_t is new Interfaces.C.unsigned_char;
    type speed_t is new Interfaces.C.unsigned;
    type cc_array is array (Natural range 0 .. NCCS - 1) of cc_t;

    --!pp off
    type c_lflag_t is (ISIG,
                       ICANON,
                       XCASE,
                       Unused1,
                       ECHO,
                       ECHOE,
                       ECHOK,
                       Unused2,
                       ECHONL,
                       NOFLSH,
                       TOSTOP,
                       Unused3,
                       ECHOCTL,
                       ECHOPRT,
                       ECHOKE,
                       Unused4,
                       FLUSHO,
                       Unused5,
                       PENDIN);

    for c_lflag_t use
      (ISIG    => 16#0000001#,
       ICANON  => 16#0000002#,
       XCASE   => 16#0000004#,
       Unused1 => 16#0000008#,
       ECHO    => 16#0000010#,
       ECHOE   => 16#0000020#,
       ECHOK   => 16#0000040#,
       Unused2 => 16#0000080#,
       ECHONL  => 16#0000100#,
       NOFLSH  => 16#0000200#,
       TOSTOP  => 16#0000400#,
       Unused3 => 16#0000800#,
       ECHOCTL => 16#0001000#,
       ECHOPRT => 16#0002000#,
       ECHOKE  => 16#0004000#,
       Unused4 => 16#0008000#,
       FLUSHO  => 16#0010000#,
       Unused5 => 16#0020000#,
       PENDIN  => 16#0040000#
      );
    --!pp on

    pragma Warnings (Off, "bits of *unused");
    type Local_Flags is array (c_lflag_t) of Boolean with
        Pack,
        Size => 32;
    pragma Warnings (On, "bits of *unused");

    type Termios is record
        c_iflag  : tcflag_t;
        c_oflag  : tcflag_t;
        c_cflag  : tcflag_t;
        c_lflag  : Local_Flags;
        c_line   : cc_t;
        c_cc     : cc_array;
        c_ispeed : speed_t;
        c_ospeed : speed_t;
    end record with
        Convention => C;

    function tcgetattr (File_Descriptor : FD; Terminal : System.Address) return BOOL with
        Import     => True,
        Convention => C;

    type Application_Time is
        (TCSANOW,   -- immediate effect
         TCSADRAIN, -- after all output written
         TCSAFLUSH  -- like drain, except input received as well
    );
    for Application_Time use (TCSANOW => 0, TCSADRAIN => 1, TCSAFLUSH => 2);

    function tcsetattr
        (File_Descriptor : FD; Effect_Time : Application_Time; Terminal : System.Address) return BOOL with
        Import     => True,
        Convention => C;

end Trendy_Terminal.Linux;

*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 03/21/2021 at 18:29:58
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: PUFLE_TESTV.....................................*
TABLES: PUFLE_TESTV, *PUFLE_TESTV. "view work areas
CONTROLS: TCTRL_PUFLE_TESTV
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_PUFLE_TESTV. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_PUFLE_TESTV.
* Table for entries selected to show on screen
DATA: BEGIN OF PUFLE_TESTV_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE PUFLE_TESTV.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF PUFLE_TESTV_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF PUFLE_TESTV_TOTAL OCCURS 0010.
INCLUDE STRUCTURE PUFLE_TESTV.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF PUFLE_TESTV_TOTAL.

*.........table declarations:.................................*
TABLES: PUFLE_TEST                     .

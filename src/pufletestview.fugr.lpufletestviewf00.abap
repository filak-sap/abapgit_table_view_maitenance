*---------------------------------------------------------------------*
*    view related FORM routines
*   generation date: 03/21/2021 at 18:29:58
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: PUFLE_TESTV.....................................*
FORM GET_DATA_PUFLE_TESTV.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM PUFLE_TEST WHERE
(VIM_WHERETAB) .
    CLEAR PUFLE_TESTV .
PUFLE_TESTV-MANDT =
PUFLE_TEST-MANDT .
PUFLE_TESTV-BUKRS =
PUFLE_TEST-BUKRS .
PUFLE_TESTV-WAERS =
PUFLE_TEST-WAERS .
<VIM_TOTAL_STRUC> = PUFLE_TESTV.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_PUFLE_TESTV .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO PUFLE_TESTV.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_PUFLE_TESTV-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM PUFLE_TEST WHERE
  BUKRS = PUFLE_TESTV-BUKRS .
    IF SY-SUBRC = 0.
    DELETE PUFLE_TEST .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM PUFLE_TEST WHERE
  BUKRS = PUFLE_TESTV-BUKRS .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR PUFLE_TEST.
    ENDIF.
PUFLE_TEST-MANDT =
PUFLE_TESTV-MANDT .
PUFLE_TEST-BUKRS =
PUFLE_TESTV-BUKRS .
PUFLE_TEST-WAERS =
PUFLE_TESTV-WAERS .
    IF SY-SUBRC = 0.
    UPDATE PUFLE_TEST ##WARN_OK.
    ELSE.
    INSERT PUFLE_TEST .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_PUFLE_TESTV-UPD_FLAG,
STATUS_PUFLE_TESTV-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_PUFLE_TESTV.
  SELECT SINGLE * FROM PUFLE_TEST WHERE
BUKRS = PUFLE_TESTV-BUKRS .
PUFLE_TESTV-MANDT =
PUFLE_TEST-MANDT .
PUFLE_TESTV-BUKRS =
PUFLE_TEST-BUKRS .
PUFLE_TESTV-WAERS =
PUFLE_TEST-WAERS .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_PUFLE_TESTV USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE PUFLE_TESTV-BUKRS TO
PUFLE_TEST-BUKRS .
MOVE PUFLE_TESTV-MANDT TO
PUFLE_TEST-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'PUFLE_TEST'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN PUFLE_TEST TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'PUFLE_TEST'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*

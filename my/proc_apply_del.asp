<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<%
	Dim apply_gubun, apply_no
	apply_gubun = request("apply_gubun")
	apply_no	= request("apply_no")

	'apply_gubun = 1:��������ȸ(���丵), 2:Ư��, 3:AI ȭ�����

	ConnectDB DBCon, Application("DBInfo_FAIR")
		Dim strQuery, strTitle

		If apply_gubun = "1" Then 
			strTitle = "������ Ư��&���"
			strQuery = ""

			strQuery = strQuery & " DELETE ���_��������"
			strQuery = strQuery & " WHERE ���_��Ϲ�ȣ = (SELECT ���_��Ϲ�ȣ FROM ���_��û���� WHERE IDX = "& apply_no &")"
			strQuery = strQuery & " AND ���ξ��̵� = (SELECT ���ξ��̵� FROM ���_��û���� WHERE IDX = "& apply_no &")"

			strQuery = strQuery & " DELETE ���_��û���� WHERE IDX = " & apply_no
			Call execSQL(DBCon, strQuery, "", "")

		ElseIf apply_gubun = "2" Then 
			strTitle = "��.â��Ư��"
			strQuery = "DELETE ���丵_����_��û���� WHERE IDX = " & apply_no
			Call execSQL(DBCon, strQuery, "", "")

		ElseIf apply_gubun = "3" Then 
			strTitle = "AI ȭ�����"
			strQuery = "DELETE ���丵_AI_ȭ����� WHERE IDX = " & apply_no
			Call execSQL(DBCon, strQuery, "", "")

		End If

	DisconnectDB DBCon

	Response.Write "<script language=javascript>"&_
		"alert('"& strTitle &" ��û��Ұ� �Ϸ�Ǿ����ϴ�.');"&_
		"location.href='/my/default.asp';"&_
		"</script>"
	response.End
%>
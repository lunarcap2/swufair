<%
	Response.CharSet="euc-kr"
    Session.codepage="949"
    Response.codepage="949"
    Response.ContentType="text/html;charset=euc-kr"
%>

<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim gubun, user_nm, biz_num, biz_nm, hp_num, email
	Dim strSql1, strSql2, strSql3, rtn_value

	gubun		= Request("gubun")
	user_nm		= unescape(Request.form("user_nm"))
	biz_num		= Request("biz_num")
	biz_nm		= unescape(Request.form("biz_nm"))
	hp_num		= Request("hp_num")
	email		= Request("email")	

	ConnectDB DBCon, Application("DBInfo_FAIR")

	strSql2 = "SELECT ���ξ��̵� FROM ����ȸ������ WITH(NOLOCK) WHERE ����= '" & user_nm & "' "
	strSql3 = "SELECT ȸ����̵� FROM ȸ������ WITH(NOLOCK) WHERE ����ڵ�Ϲ�ȣ= '" & biz_num & "' AND ����ڼ��� = '" & biz_nm & "' "
	
	Select Case gubun
		Case "User_S"	: strSql1 = strSql2 & " AND �޴��� = '" & hp_num & "'"
		Case "User_E"	: strSql1 = strSql2 & " AND ���ڿ��� = '" & email & "'"
		Case "Biz_S"	: strSql1 = strSql3 & " AND ������޴��� = '" & hp_num & "'"
		Case "Biz_E"	: strSql1 = strSql3 & " AND ���ڿ��� = '" & email & "'" 
	End Select
	
	rtn_value = arrGetRsParam(DBCon, strSql1, "", "", "")

	If isArray(rtn_value) Then
		Response.write "1"
	End If	
	
	DisconnectDB DBCon
%>
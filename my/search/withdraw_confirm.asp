<%
	session.codepage = "65001"
	response.expires = -1
	response.cachecontrol = "no-cache"
	response.charset = "utf-8"
%>

<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/wwwconf/function/library/KISA_SHA256.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim pw, rtn_value

	pw	= Request("user_pw")

	ConnectDB DBCon, Application("DBInfo_FAIR")

	strSql = "SELECT ��ȣȭ_��й�ȣ FROM ����ȸ������ WITH(NOLOCK) WHERE ���ξ��̵�= ? "
	
	ReDim parameter(0)
	parameter(0)	= makeParam("@���ξ��̵�", adVarchar, adParamInput, 20, user_id)
	rtn_value		= arrGetRsParam(DBCon, strSql, parameter, "", "")

	If isArray(rtn_value) Then
		If SHA256_Encrypt(pw) = rtn_value(0,0) Then
			Response.write "S"
		End If
	End If	
	
	DisconnectDB DBCon
%>
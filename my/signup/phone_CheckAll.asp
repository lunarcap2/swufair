<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/common/common.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: ����/���ȸ�� ����
' 	History		: 2020-05-11, �̻��� 
'---------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1

user_phone = Request("user_phone")

ConnectDB DBCon, Application("DBInfo_FAIR")


' �޴�����ȣ �ߺ� üũ
strSql = "SELECT �޴��� FROM ����ȸ������ WITH(NOLOCK) WHERE �޴��� = ? "
Dim param(0)
param(0)		= makeParam("@�޴���", adVarchar, adParamInput, 40, user_phone)
ArrRsDefault	= arrGetRsParam(DBCon, strSql, param, "", "")
If isArray(ArrRsDefault) Then
	rtn_value = "X"	
Else
	rtn_value = "O"
End If


DisconnectDB DBCon


Response.write rtn_value
%>
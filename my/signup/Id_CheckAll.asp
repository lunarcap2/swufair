<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: ����/���ȸ�� ����
' 	History		: 2020-04-20, �̻��� 
'---------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1

user_id = Request("user_id")

ConnectDB DBCon, Application("DBInfo_FAIR")

' �Է� ���̵� �ߺ� üũ
SpName="usp_ID_CheckAll"
	Dim param(1)
	param(0)=makeParam("@user_id", adVarChar, adParamInput, 20, user_id)
	param(1)=makeParam("@rtn", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName, param, "", "")

	sp_rtn = getParamOutputValue(param, "@rtn")

DisconnectDB DBCon


Response.write sp_rtn
%>
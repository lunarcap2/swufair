<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/inc/function/auth/clearCookie.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim user_nm, hp_num, user_reason, remote_addr, rtn
	
	user_nm		= Request("user_nm")
    hp_num		= Request("hp_num")
    user_reason	= Request("user_reason")

	If user_nm <> user_name Then
		Response.write "<script type='text/javascript'>" &_
					   "alert('�Է��� ������ ��ġ���� �ʽ��ϴ�.');" &_
					   "document.location.href='/my/search/withdraw.asp';" &_
					   "</script>"
		
	End If

	If hp_num <> emobile Then
		Response.write "<script language='javascript'>" &_
					   "alert('�Է��� �޴�����ȣ�� ��ġ���� �ʽ��ϴ�.');" &_
					   "document.location.href='/my/search/withdraw.asp';" &_
					   "</script>"
		Response.end
	End If

	ConnectDB DBCon, Application("DBInfo_FAIR")
	
	SpName="USP_ACCOUNT_DEL"
	
	ReDim param(7)
	param(0) = makeParam("@userId", adVarChar, adParamInput, 20, user_id)
	param(1) = makeParam("@REMOTE_ADDR", adVarChar, adParamInput, 100, remote_addr)
	param(2) = makeParam("@user_name", adVarChar, adParamInput, 50, user_nm)
	param(3) = makeParam("@regnum", adVarChar, adParamInput, 13, "")
    param(4) = makeParam("@iReason", adChar, adParamInput, 1, "5") ' 1:�������, 2:������ ����, 6:���� ����, 3:���̵�/�̸� ����, 4:�������� ������, 5:��Ÿ
	param(5) = makeParam("@iReason_Content", adVarChar, adParamInput, 5000, user_reason)
	param(6) = makeParam("@rtn", adChar, adParamOutput, 1, rtn)
	param(7) = makeParam("@siteGubunCode", adVarChar, adParamInput, 2, "1")
	
	Call execSP(DBCon, SpName, param, "", "")
	
	rtn = getParamOutputValue(param, "@rtn")
	
	If rtn = "X" Then
		Response.write "<script type='text/javascript'>" &_
					   "alert('ó�� ���� ������ �߻��Ͽ����ϴ�.\n�ٽ� �õ����ֽñ� �ٶ��ϴ�.');" &_
					   "document.location.href='/my/search/withdraw.asp';" &_
					   "</script>"
		Response.end
	Else
		Call ClearCookieWK

		Response.write "<script language='javascript'>" &_
					   "alert('���� ä��� ȸ��Ż�� �Ϸ�Ǿ����ϴ�.');" &_
					   "document.location.href='/default.asp';" &_
					   "</script>"
		Response.end
	End If
	
	DisconnectDB DBCon
%>


<% Option Explicit %>

<!--#include virtual = "/common/constant.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/CryptoHelper.asp"-->
<!--#include virtual = "/wwwconf/function/library/KISA_SHA256.asp"-->

<%
	dim id : id = Request.Form("id")
	dim pw : pw = SHA256_Encrypt(Request.Form("pw"))
	Dim rtnvalue : rtnvalue = ""

	ConnectDB DBCon, Application("DBInfo_FAIR")

	Dim Param(2)
	Dim arrayList(0)
	
	Param(0) = makeparam("@admin_id",adVarChar,adParamInput,50,id )
	Param(1) = makeparam("@admin_pw",adVarChar,adParamInput,100,pw)
	Param(2) = makeparam("@rtn",adChar,adParamOutput,1,"")

	Call execSP(DBcon,"sp_admin_logincheck",Param,"","")
	rtnvalue= getParamOutputValue(Param,"@rtn")

	DisconnectDB DBCon

	if rtnvalue = "3" then
		Response.Write "<script language='javascript'>alert('���̵� �߸� �Է� �ϼ̽��ϴ�.'); history.back();</script>" 
	end if

	if rtnvalue = "2" then
		Response.Write "<script language='javascript'>alert('��й�ȣ�� �߸� �Է� �ϼ̽��ϴ�.'); history.back();</script>" 
	end if
	
	if rtnvalue = "4" then
		Response.Write "<script language='javascript'>alert('��й�ȣ�� 5ȸ �߸� �Է� �Ͽ� ������ �����ϴ�.\r����� 02-2006-9519 �� �����ּ���.'); history.back();</script>" 
	end if

	if rtnvalue="1" Then
		Response.Cookies(site_code & "WKADMIN")("admin_id") = id
		Response.Cookies(site_code & "WKADMIN").Domain		= "career.co.kr"	' ������ ����
		Response.Redirect "/admin/default.asp"
	end If

%>
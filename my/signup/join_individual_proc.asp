 <!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/library/KISA_SHA256.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: ����ȸ�� ����
' 	History		: 2020-04-20, �̻��� 
'---------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1


Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

Dim txtId, txtPass, txtName, txtBirth, txtEmail, chkAgrMail, txtPhone, chkAgrSms, compId, encPass

txtId		= RTrim(LTrim(Replace(Request("txtId"), "'", "''")))	' ���̵�
txtPass		= Replace(Request("txtPass"), "'", "''")				' ��й�ȣ	
txtPhone	= Request("txtPhone")	' �޴�����ȣ
selGrad		= Request("selGrad")	' ���� �� ���п���
txtName		= RTrim(LTrim(Replace(Replace(Request("txtName"), "'", "''"), " ", "")))	' �̸�
txtMajor	= RTrim(LTrim(Replace(Replace(Request("txtMajor"), "'", "''"), " ", "")))	' �а�


rdoStudent	= Request("rdoStudent")	' ���л�/Ÿ��� ����
txtStuNo	= RTrim(LTrim(Replace(Request("txtStuNo"), "'", "''")))	' �й�
txtUnivNm	= RTrim(LTrim(Replace(Replace(Request("txtUnivNm"), "'", "''"), " ", "")))	' �б�
rdoGender	= Request("rdoGender")	' ����


'------------ �̻�� �׸� ------------ 
txtBirth	= RTrim(LTrim(Replace(Replace(Request("txtBirth"), "'", "''"), " ", "")))	' �������
txtEmail	= RTrim(LTrim(LCase(Replace(Request("txtEmail"), " ", ""))))	' �̸���
chkAgrMail	= Request("chkAgrMail")		' ȫ���� ���� ���� ����
chkAgrSms	= Request("chkAgrSms")		' ȫ���� ���� ���� ����


' ���л�/Ÿ��� ���п� ���� ��� ���̵� �� ����
If rdoStudent="1" Then 
	txtId = txtStuNo
Else 
	txtId = txtId
End If 

' ���� ����
If rdoGender="1" Then 
	rdoGender = "M"
Else 
	rdoGender = "F"
End If 

' ����ó�� ������ ������ ��� ���� ����
Dim len_txtPhone, strPhone
If InStr(txtPhone,"-")=0 Then 
	len_txtPhone	= Len(txtPhone)
	strPhone		= Left(txtPhone,3)&"-"&Mid(txtPhone,4,len_txtPhone-7)&"-"&Right(txtPhone,4)
Else 
	strPhone		= txtPhone
End If 


' �������� ��η� �̵����� ���� ��� ȸ������ ȭ������ ����
If Len(txtId) = 0 Or Len(txtPass) = 0 Then Response.Write "<meta http-equiv='refresh' content='0; url=http://" & Request.ServerVariables("SERVER_NAME") & "/my/signup/join.asp'>"


compId	= txtId&"_wk"				' ����ȸ�����̵�+"_wk" ����		
encPass = SHA256_Encrypt(txtPass)	' ��� ��ȣȭ(sha256 ���)


ConnectDB DBCon, Application("DBInfo_FAIR")


' �Է� ���̵� �ߺ� üũ
SpName="usp_ID_CheckAll"
	Dim chkparam(1)
	chkparam(0)=makeParam("@user_id", adVarChar, adParamInput, 20, compId)
	chkparam(1)=makeParam("@rtn", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName, chkparam, "", "")

	rsltCmt = getParamOutputValue(chkparam, "@rtn")


If rsltCmt = "O" Then ' �Է��� ���̵�� ���� ���Ե� ������ ������ ȸ�� ����
		
	SpName="usp_ȸ������_����_��ȣȭ"
		Dim param(14)
		param(0)=makeParam("@���ξ��̵�", adVarChar, adParamInput, 20, compId)
		param(1)=makeParam("@��ȣȭ_��й�ȣ", adVarChar, adParamInput, 100, encPass)
		param(2)=makeParam("@����", adVarChar, adParamInput, 30, txtName)
		param(3)=makeParam("@�������", adVarChar, adParamInput, 10, txtBirth)
		param(4)=makeParam("@���ڿ���", adVarChar, adParamInput, 100, txtEmail)
		param(5)=makeParam("@�޴���", adVarChar, adParamInput, 20, strPhone)
		param(6)=makeParam("@���ϼ��ſ���", adChar, adParamInput, 1, chkAgrMail)
		param(7)=makeParam("@SMS����", adChar, adParamInput, 1, chkAgrSms)
		param(8)=makeParam("@�а�", adVarChar, adParamInput, 50, txtMajor)
		param(9)=makeParam("@��������", adChar, adParamInput, 1, selGrad)		

		param(10)=makeParam("@����", adChar, adParamInput, 1, rdoGender)		
		param(11)=makeParam("@�б�", adVarChar, adParamInput, 50, txtUnivNm)

		param(12)=makeParam("@����Ʈ����", adChar, adParamInput, 2, "W")
		param(13)=makeParam("@���Ի���Ʈ�����ڵ�", adChar, adParamInput, 2, "1")
		param(14)=makeParam("@rtn", adChar, adParamOutput, 1, "")
	
		Call execSP(DBCon, SpName, param, "", "")

		sp_rtn = getParamOutputValue(param, "@rtn")	

	
	If sp_rtn = "O" Then	' ���� ���� �Ϸ� �� �ڵ��α��� ó��

		'#### ���� ��� ����
		Dim strSql, strRemoteAddr, strUserAgent
		strRemoteAddr	= Request.ServerVariables("REMOTE_ADDR")
        strUserAgent	= Request.ServerVariables("HTTP_USER_AGENT")	
		strSql = "INSERT INTO ȸ������ȯ������(ȸ�����̵�, ���Ծ�����, ����ȯ��) VALUES('"&compId&"', '"&strRemoteAddr&"', '"&strUserAgent&"')"
		DBCon.Execute(strSql)


		'#### ȸ������ ��Ű �Ҵ�
		Response.Cookies(site_code & "WKP_F")("id")			= Replace(compId, "_wk", "")
		Response.Cookies(site_code & "WKP_F")("name")		= txtName
'		Response.Cookies(site_code & "WKP_F")("email")		= txtEmail
		Response.Cookies(site_code & "WKP_F")("cellphone")	= strPhone
		Response.Cookies(site_code & "WKP_F").Domain		= "career.co.kr"
		'Response.Cookies("WKP_F").Domain	= Request.ServerVariables("SERVER_NAME")	' ������ ����

		Response.Write "<script language=javascript>"&_
		 "alert('������û �Ϸ�Ǿ����ϴ�.');"&_
		"location.href='/';"&_
		"</script>"
		response.End 

	Else ' ȸ�� ���� ���� �� ���� �߻� ����
		Response.Write "<script language=javascript>"&_
		 "alert('������û �� ������ �߻��߽��ϴ�.\n�ٽ� �õ��� �ּ���.');"&_
		"location.href='/my/signup/join.asp';"&_
		"</script>"
		response.End 
	End If 
Else	' �Է��� ���̵�� ���Ե� ������ ������ ��� ȸ�� ���� ������ ����
	Response.Write "<script language=javascript>"&_
	 "alert('�Է��Ͻ� ���̵�� ������û�� ������ �����մϴ�.\n�ٸ� ���̵�� �ٽ� �õ��� �ּ���.');"&_
	"location.href='/my/signup/join.asp';"&_
	"</script>"
	response.End 
End If 

DisconnectDB DBCon
%>
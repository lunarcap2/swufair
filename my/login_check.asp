<% Option Explicit %>

<!--#include virtual = "/common/constant.asp"-->
<!--#include virtual = "/wwwconf/function/library/CryptoHelper.asp"-->
<!--#include virtual = "/wwwconf/function/library/KISA_SHA256.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim hostnm		: hostnm	= "http://" & Request.ServerVariables("SERVER_NAME")
	Dim from		: from		= Request("from")
	Dim msg			: msg		= ""
	Dim logtype		: logtype	= "1"  ' ���ηα���

	redir = Request("redir")

	Dim strSql, idCnt
	Dim ErrURL
	Dim mem_root, mem_root_txt
	Dim pagegb		: pagegb	= Request("pagegb")
	Dim hLog		: hLog		= Request("hLog")  ' �α��� �� �Ի������Ҷ�  history.back �� Ƚ��
	
	Dim fairName	: fairName	= request("fairName")
	If hLog ="" Or IsNumeric(hLog)=false Then
		hLog = 2
	Else
		hLog = hLog + 1
	End If

	If Trim(redir)="" Then redir = hostnm
	If InStr(1,redir,"http") = 0 Then redir = hostnm & redir

	' ����ȸ�����̵� "_wk"�� ���δ�.
	Dim id		: id	= Replace(Request.Form("id"), "'", "''")
	Dim pw		: pw	= Replace(Request.Form("pw"), "'", "''") 
	Dim sa_no	: sa_no = Request.Form("sa_no")
	Dim get_user_id, get_user_pw, get_user_name, get_user_address, get_user_email, get_user_photo, get_cellphone

	Dim email_str, user_cellphone, mail_flag1, mail_flag2
	Dim jumin1, jumin2, strSql2, birth_year
	Dim motiSql, motiSqlSoldier, gubun, InseedKey

	If Trim(id) = "" Then Response.Write "<meta http-equiv='refresh' content='0; url="& hostnm &"/my/login.asp'>"
	
	'********** ����ȸ������ ���̺� ��� üũ
	dbCon.Open Application("DBInfo_FAIR")

	strSql = "SELECT ���ξ��̵�, ����, isnull(���ڿ���,''), ��ȣȭ_��й�ȣ, �޴���, �ּ�, �������� " &_
		      " FROM ����ȸ������ WITH(NOLOCK)" &_
		      " WHERE ���ξ��̵�='" & id & "_wk' AND ����Ʈ���� IN ('W','A','U','N','P','M','K','Q','AT','PA','KA') "

	Rs1.Open strSql, dbCon, 0, 1

	If (Rs1.BOF = False And Rs1.EOF = False) Then
		If SHA256_Encrypt(pw) = rs1("��ȣȭ_��й�ȣ") Then
			Call ClearCookieWK  ' ��� ��Ű reset

			get_user_id			= Rs1.Fields(0).Value
			get_user_name		= Rs1.Fields(1).Value
			get_user_email		= Rs1.Fields(2).Value
			get_cellphone		= Rs1.Fields(4).Value
			get_user_address	= Rs1.Fields(5).Value
			get_user_photo		= Rs1.Fields(6).Value

			Rs1.Close

			ErrURL = redir

			'#### ȸ������ ��Ű�Ҵ�
			Response.Cookies(site_code & "WKP_F")("id")			= Replace(get_user_id, "_wk", "")
			Response.Cookies(site_code & "WKP_F")("name")		= get_user_name
			Response.Cookies(site_code & "WKP_F")("email")		= get_user_email
			Response.Cookies(site_code & "WKP_F")("cellphone")	= get_cellphone
			Response.Cookies(site_code & "WKP_F")("address")	= get_user_address
			Response.Cookies(site_code & "WKP_F")("photo")		= get_user_photo

			'�̷¼��Ǽ�(�̿Ϸ�� �̷¼��� ī��ƮX)
			strSql = "SELECT COUNT(��Ϲ�ȣ), isnull(sum(case ����ڵ� when '1' then 1 else 0 end),0), isnull(sum(case ����ڵ� when '8' then 1 else 0 end),0) " &_
					 "  FROM �̷¼� WITH(NOLOCK) WHERE ���ξ��̵�='" & id & "_wk' and �ܰ� <> '0' "
			
			Rs1.Open strSql, dbCon, 0, 1

			CK_ResumeCnt1	= Rs1.Fields(0)
			CK_ResumeCnt11	= Rs1.Fields(1)	' �����̷¼�
			CK_ResumeCnt12	= Rs1.Fields(2)	' ����̷¼�

			Response.Cookies(site_code & "WKP_F")("CK_ResumeCnt")	= CK_ResumeCnt1
			Response.Cookies(site_code & "WKP_F")("CK_ResumeCnt1")	= CK_ResumeCnt11
			Response.Cookies(site_code & "WKP_F")("CK_ResumeCnt2")	= CK_ResumeCnt12
			
			Rs1.Close

			dbCon.Close

			'Response.Cookies("WKP_F").Domain		= Request.ServerVariables("SERVER_NAME")	' ������ ����
			Response.Cookies(site_code & "WKP_F").Domain = "career.co.kr"	' ������ ����


			ErrURL = redir
		Else ' ���Ʋ�����
			MSG = "�Է��Ͻ� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.\r��й�ȣ�� �ٽ� Ȯ���� �ֽñ� �ٶ��ϴ�."
			ErrURL = hostnm & "/my/login.asp?redir="&Server.URLEncode(redir)
		End If
	Else ' ����ȸ������ ���̺� ����
		MSG = "�Է��Ͻ� ���̵� �������� �ʽ��ϴ�.\r���̵� �ٽ� Ȯ���� �ֽñ� �ٶ��ϴ�."
		ErrURL = hostnm & "/my/login.asp?redir="&Server.URLEncode(redir)
	End If
%>

<%IF Request.Form("WINTYPE") = "POP" THEN%>
	<script type="text/javascript">
	<%If MSG <> "" then%>
		alert('<%=msg%>');
		history.back();
	<%ELSE%>
	   location.href = "http://<%=Request.Form("HOSTNM")%>/login/ie8msg.asp?redir=<%=redir%>"
	<%END IF%>
	</script>
<%ELSE%>
	<script type="text/javascript">
	<%If MSG <> "" Then%>
		alert('<%=msg%>');
	<%End If%>
	</script>

	<META HTTP-EQUIV="REFRESH" CONTENT="0; URL=<%=ErrURL%>"></head>
	<body>
	</body>
	</html>
<%END IF%>

<OBJECT RUNAT="SERVER" PROGID="ADODB.Connection" ID="dbCon"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs1"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.Connection" ID="dbCon2"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.Connection" ID="dbCon3"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs2"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs3"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs4"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.Connection" ID="dbConSpec"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.Command" ID="Cmd" VIEWASTEXT></OBJECT>
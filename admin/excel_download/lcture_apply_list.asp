<%Option Explicit%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->

<%
	Response.CharSet = "euc-kr"
	Response.ContentType = "application/x-msexcel"
	Response.CacheControl  = "public"
	Response.AddHeader  "Content-Disposition", "attachment;filename=���￩��_Ư����û��.xls"

	Dim gubun		: gubun			= Request("gubun")
	Dim schKeyword	: schKeyword	= Request("schKeyword") ' �˻���(����/����)
	Dim lctureDay	: lctureDay		= Request("lctureDay")
	Dim lctureTit	: lctureTit		= Request("lctureTit")
	Dim page		: page			= Request("page")
	Dim pageSize	: pageSize		= 10000

	If page = "" Then page=1
	page = CInt(page)

	If lctureDay = "" Then lctureDay = ""
	If lctureTit = "" Then lctureTit = ""

	Dim stropt, i, ii
	stropt = "gubun=" & gubun & "&schKeyword=" & schKeyword & "&lctureDay=" & lctureDay & "&lctureTit=" & lctureTit

	ConnectDB DBCon, Application("DBInfo_FAIR")

		ReDim Param(6)
		Param(0) = makeparam("@KW_GUBUN",adVarChar,adParamInput,100,gubun)
		Param(1) = makeparam("@KW",adVarChar,adParamInput,100,schKeyword)
		Param(2) = makeparam("@S_DATE",adVarChar,adParamInput,10,lctureDay)
		Param(3) = makeparam("@LCTURE_TIT",adVarChar,adParamInput,100,lctureTit)
		Param(4) = makeparam("@PAGE",adInteger,adParamInput,4,page)
		Param(5) = makeparam("@PAGE_SIZE",adInteger,adParamInput,4,pagesize)
		Param(6) = makeparam("@TOTAL_CNT",adInteger,adParamOutput,4,"")

		Dim arrRs, totalCnt, pageCount
		arrRs = arrGetRsSP(DBcon, "asp_������_Ư����û��_����Ʈ", Param, "", "")
		totalCnt = getParamOutputValue(Param, "@TOTAL_CNT")
		pageCount = int(totalCnt / pagesize) + 1

	DisconnectDB DBCon
%>

<!DOCTYPE html>
<html lang="ko">
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<head>
</head>

<body>
	<table border="1" cellpadding="0" cellspacing="0" summary="">
		<colgroup>
			<col style="width:50px" />
			<col style="width:200px" />
			<col style="width:220px" />
			<col style="width:200px" />
			<col style="width:200px" />
			<col />
		</colgroup>

		<thead>
			<tr height="50">
				<th style="background-color:#dfdfdf;">No</th>
				<th style="background-color:#dfdfdf;">Ư��</th>
				<th style="background-color:#dfdfdf;">�Ͻ�</th>
				<th style="background-color:#dfdfdf;">��û�� �̸�(ID)</th>
				<th style="background-color:#dfdfdf;">��û�� �޴�����ȣ</th>
				<th style="background-color:#dfdfdf;">Ư�� ��û��</th>
			</tr>
		</thead>

		<tbody>
			<%
				If isArray(arrRs) Then
					For i=0 To UBound(arrRs,2)
					Dim lcture_no, lcture_tit, lcture_day, lcture_applyName, lcture_applyId, lcture_applyHp, lcture_applyDay
					lcture_no			= arrRs(1,i)	' No
					lcture_tit			= arrRs(2,i)	' ���Ǹ�
					lcture_day			= arrRs(3,i)	' ���ǽ����Ͻ�
					lcture_applyName	= arrRs(4,i)	' Ư����û��_����
					lcture_applyId		= arrRs(5,i)	' Ư����û��_���̵�
					lcture_applyHp		= arrRs(6,i)	' Ư����û��_�޴���
					lcture_applyDay		= arrRs(7,i)	' Ư����û��_�����
			%>
			<tr align="center">
				<td><%=lcture_no%></td>
				<td><%=lcture_tit%></td>
				<td><%=lcture_day%></td>
				<td><%=lcture_applyName%>(<%=Replace(lcture_applyId,"_wk","")%>)</td>
				<td><%=lcture_applyHp%></td>
				<td><%=lcture_applyDay%></td>
			</tr>
			<%
					Next
				End If
			%>
		</tbody>
	</table>
</body>
</html>

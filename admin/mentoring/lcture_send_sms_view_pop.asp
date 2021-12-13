<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
<!--#include virtual = "/inc/function/paging_ajax.asp"-->

<%
ConnectDB DBCon, Application("DBInfo_FAIR")
	
	Dim montoring_date, montoring_no
	montoring_date	= request("montoring_date")
	montoring_no	= request("montoring_no")


	ReDim Param(1)
	Param(0) = makeparam("@consultDay",adVarChar,adParamInput,10,montoring_date)
	Param(1) = makeparam("@consultNo",adInteger,adParamInput,4,montoring_no)

	Dim arrRsMentor
	arrRsMentor = arrGetRsSP(DBcon, "asp_������_Ư�����ڹ߼�_����Ʈ", Param, "", "")

	Dim lcture_day, lcture_tit, lcture_stime, lcture_etime
	lcture_day		= arrRsMentor(2, 0)
	lcture_tit		= arrRsMentor(1, 0)
	lcture_stime	= arrRsMentor(3, 0)
	lcture_etime	= arrRsMentor(4, 0)

	Dim page, pageSize
	page = request("page")
	pageSize = 50

	If page = "" Then page = 1
	page = CInt(page)


	ReDim Param(6)
	Param(0) = makeparam("@KW_GUBUN",adVarChar,adParamInput,100,"")
	Param(1) = makeparam("@KW",adVarChar,adParamInput,100,"")
	Param(2) = makeparam("@S_DATE",adVarChar,adParamInput,10,montoring_date)
	Param(3) = makeparam("@LCTURE_TIT",adVarChar,adParamInput,100,montoring_no)
	Param(4) = makeparam("@PAGE",adInteger,adParamInput,4,page)
	Param(5) = makeparam("@PAGE_SIZE",adInteger,adParamInput,4,pageSize)
	Param(6) = makeparam("@TOTAL_CNT",adInteger,adParamOutput,4,"")

	Dim arrRs, totalCnt, pageCount
	arrRs		= arrGetRsSP(DBcon, "asp_������_Ư����û��_����Ʈ", Param, "", "")
	totalCnt	= getParamOutputValue(Param, "@TOTAL_CNT")
	pageCount	= Fix(((totalCnt-1)/PageSize) +1) 'int(totalCnt / pagesize) + 1

DisconnectDB DBCon
%>

<div class="info_box">
	<dl class="ib_dl">
		<dt>
			<span><%=lcture_tit%></span>
		</dt>
		<dd>
			<span class="ib_time">������� �Ͻ�<br><%=lcture_day%> / <%=lcture_stime%>~<%=lcture_etime%></span>
		</dd>
		<dd class="logo">
			<div class="logo_box">
			</div>
		</dd>
	</dl>
</div>
<div class="tb_area scroll">
	<div class="th_bg"></div>
	<div class="tb_wrap">
		<table class="tb" summary="��ܺ���">
			<caption>��ܺ���</caption>
			<colgroup>
					<col style="width:10%;">
					<col style="width:22%;">
					<col style="width:24%;">
					<col style="width:17%;">
				</colgroup>
				<thead>
					<tr>
						<th class="cell1"><span>No</span></th>
						<th class="cell2"><span>�̸� (ID)</span></th>
						<th class="cell4"><span>�޴�����ȣ</span></th>
						<th class="cell5"><span>��û��</span></th>
					</tr>
				</thead>
			<tbody>
				<%
					If isArray(arrRs) Then
						For i=0 To UBound(arrRs, 2)
				%>
				<tr>
					<td><%=arrRs(1, i)%></td>
					<td><%=arrRs(4, i)%>(<%=Replace(arrRs(5, i), "_wk", "")%>)</td>
					<td><%=arrRs(6, i)%></td>
					<td><%=Left(arrRs(7, i), 10)%></td>
				</tr>
				<%
						Next
					End If 
				%>
			</tbody>
		</table>
	</div>

	<% Call putPage(page, stropt, pageCount, "fn_pop_sms_pageingView") %>
</div>
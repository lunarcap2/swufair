<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<%
'--------------------------------------------------------------------
'   Comment		: �Խ��� ���� - ���/����
' 	History		: 2020-07-20, �̻��� 
'--------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1


'If Request.ServerVariables("HTTPS") = "off" Then 
'	Response.redirect "https://"& Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("URL") 
'End If

If Request.ServerVariables("HTTPS") = "on" Then 
	Response.redirect "http://"& Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("URL") & "?" & Request.ServerVariables("QUERY_STRING")
End If

' ������ ������ ��쿡�� ���� ���   
If Request.Cookies(site_code & "WKADMIN")("admin_id")="" Then 
	Response.Write "<script language=javascript>"&_
		"alert('�ش� �޴��� ���� ���� ������ �����ϴ�.');"&_
		"location.href='/';"&_
		"</script>"
	response.End 
End If


Dim seq			: seq			= Request("seq")		' �Խù� ��Ϲ�ȣ

' ���� �Ķ����
Dim gubun		: gubun			= Request("gubun")		' �Խ��� ����
Dim schKeyword	: schKeyword	= Request("schKeyword") ' �˻���(����/����)  
Dim page		: page			= Request("page")

If gubun = "" Then 
	gubun = "1"
Else 
	gubun = gubun
End If 

Dim stropt
stropt = "gubun="&gubun&"&schKeyword="&schKeyword&"&page="&page
If seq <> "" Then 
	stropt_dtl = stropt&"&seq="&seq	
Else 
	stropt_dtl = stropt
End If 


Dim ArrRs, ArrRsFile
If seq <> "" then
	ConnectDB DBCon, Application("DBInfo_FAIR")

	ReDim Param(0)
	Param(0) = makeparam("@idx",adInteger,adParamInput,4,seq)
	ArrRs = arrGetRsSP(DBcon,"usp_board_view",Param,"","")

	gubun		= ArrRs(1,0)
	title		= ArrRs(5,0)
	content		= ArrRs(6,0)
	userName	= ArrRs(3,0)
	jobs_id		= ArrRs(2,0)
	BizName		= ArrRs(4,0)
	regDate		= Left(Trim(arrRs(9,i)),10)	' �������


	ReDim Param(1)
	Param(0)	= makeparam("@seq",adInteger,adParamInput,4,seq)
	Param(1)	= makeparam("@idx",adInteger,adParamInput,4,"")

	ArrRsFile	= arrGetRsSP(DBcon,"usp_board_files",Param,"","")


	mode = "modify"
	DisconnectDB DBCon
Else 
	userName	= "������"
	regDate		= Date()
End If 
%>
<!--#include virtual = "/include/header/header.asp"-->
<script type="text/javascript" src="https://imgs.career.co.kr/CHEditor/cheditor.js"></script>
<script type="text/javascript">
<!--
//cheditor ��ü�� �����մϴ�
var myeditor = new cheditor("myeditor");

function fn_moveType(v){
	if (v=="cancel"){
		location.href = "board_form.asp?<%=stropt_dtl%>";
	}else if (v=="list"){
		location.href = "board_list.asp?<%=stropt%>";
	}else if (v=="save"){	
		if (document.frm.title.value==""){
			alert("������ �Է��� �ּ���.");
			document.frm.title.focus();
			return;
		}

		//�󼼳���
		var ctxt = myeditor.outputBodyHTML();
		if (ctxt=="<br>"){
			ctxt = "";
		}
		document.frm.txtContent.value	= "";
		document.frm.txtContent.value	= ctxt;

		if(document.frm.txtContent.value == "") {
			alert("������ �Է��� �ּ���.");
			myeditor.editArea.focus();
			return;
		}

		document.frm.action = "./board_proc.asp";
		document.frm.submit();
	}else if (v=="del") {
		if(confirm('�ش� �Խñ��� ���� �Ͻðڽ��ϱ�?')) {
			document.frm_del.action = "./board_delete.asp";
			document.frm_del.submit();
		}
	}
}

function fn_file_del(gubun, seq, idx){
	if(confirm('�ش� ÷�������� ���� �Ͻðڽ��ϱ�?')) {
		location.href = "./board_file_delete.asp?seq="+seq+"&idx="+idx;
	}	
}

function fn_set_Tit(_val) {
	$("#gubun").val(_val);
}

function fn_load_img(obj) {
	var file_name = $(obj).val();
	$(obj).parent().find(".upload_name").val(file_name);
}

//-->
</script>
</head>
<body>

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<form method="post" id="frm_del" name="frm_del">
	<input type="hidden" name="seq" value="<%=seq%>">
	<input type="hidden" name="gubun" value="<%=gubun%>">
</form>

<!-- ���� -->
<form method="post" id="frm" name="frm" enctype="multipart/form-data">
<input type="hidden" name="seq" value="<%=seq%>">
<div id="contents" class="sub_page">

	<div class="content">
		<div class="con_box">
			<div class="notice_area">
				<div class="board_area">
					<table class="tb view" summary="��������">
						<caption>��������</caption>
						<colgroup>
							<col style="width:20%"/>
							<col style="width:30%"/>
							<col style="width:20%"/>
							<col style="width:30%"/>
						</colgroup>
						<tbody>
							<!-- <tr>
								<th>����</th>
								<td colspan="3">
									<select id="gubun_test" name="gubun_test" onclick="fn_set_Tit(this.value)" width="300px">
										<option <%'If gubun = "1" Then%>selected="selected"<%'End If%> value="1">��������</option>										
									</select>
								</td>
							</tr> -->
							<tr>
								<th>����</th>
								<td colspan="3">
									<input type="text" class="txt" id="title" name="title" value="<%=title%>" placeholder="������ �Է��� �ּ���" style="width:100%">
								</td>
							</tr>
							<tr>
								<th>�ۼ���</th>
								<td><%=userName%></td>
								<th>�ۼ���</th>
								<td><%=regDate%></td>
							</tr>
							<tr>
								<td colspan="4">
									<textarea id="txtContent" name="txtContent" style="width:100%;height:300px;"><%=content%></textarea>
									<script type="text/javascript">
										myeditor.config.editorHeight	= '300px';			// ������ �������Դϴ�.
										myeditor.config.editorWidth		= '100%';			// ������ �������Դϴ�.
										myeditor.config.imgReSize		= true;				// �̹��� ������¡ ����� ����մϴ�.
										myeditor.config.editorPath		= '/cheditor/';		// ������ ��ġ ����Դϴ�. ��� ���� '/'�� ������ �ʽ��ϴ�.
										myeditor.inputForm	= 'txtContent';					// �����ͷ� �ҷ��帱 textarea�� id �Դϴ�.
										myeditor.run();                                     // �����͸� �����մϴ�. 
									</script>
								</td>
							</tr>
							<tr>
								<th>÷������</th>
								<td colspan="3">
									<div class="file_box">
										<input type="text" class="upload_name" id="upload_name1" placeholder="÷�������� ����� �ּ���." disabled="disabled" style="width:430px;">
										<label for="file1">����ã��</label>
										<input type="file" id="file1" name="file1" onchange="fn_load_img(this);">
									</div>
									<!--
									<div class="file_box">
										<input type="text" class="upload_name" id="upload_name2" placeholder="÷�������� ����� �ּ���." disabled="disabled" style="width:430px;">
										<label for="file2">���ε�</label>
										<input type="file" id="file2" name="file2" onchange="fn_load_img(this);">
									</div>
									<div class="file_box">
										<input type="file" id="file3" name="file3" maxlength="100">
									</div>
									<div class="file_box">
										<input type="file" id="file4" name="file4" maxlength="100">
									</div>
									<div class="file_box">
										<input type="file" id="file5" name="file5" maxlength="100">
									</div>
									-->

								<%If isArray(ArrRsFile) Then%>
									<%For i=0 To UBound(ArrRsFile, 2)%>
										<div class="file_box"><a href="board_file_download.asp?filePolder=<%=ArrRsFile(5, i)%>&fileName=<%=ArrRsFile(3, i)%>&fileOrigin=<%=ArrRsFile(4, i)%>"><%=ArrRsFile(4, i)%></a> <button type="button" class="btn typeBlack" onclick="fn_file_del('<%=gubun%>', '<%=ArrRsFile(0, i)%>','<%=ArrRsFile(1, i)%>');"><strong>����</strong></button></div>
									<%Next%>
								<%End If%>

								</td>
							</tr>
	
						</tbody>
					</table>

					<div class="btn_area right">	
						<a href="javaScript:;" class="btn gray left" onclick="fn_moveType('list');">���</a>

				<%If seq="" Then%>
						<a href="javaScript:;" class="btn blue" onclick="fn_moveType('save');">����</a>
						<a href="javaScript:;" class="btn gray" onclick="fn_moveType('cancel');">���</a>					
				<%Else%>
						<a href="javaScript:;" class="btn blue" onclick="fn_moveType('del');">����</a>
						<a href="javaScript:;" class="btn blue" onclick="fn_moveType('save');">����</a>
						<a href="javaScript:;" class="btn gray" onclick="fn_moveType('cancel');">���</a>					
				<%End If%>
					</div>
				</div><!--//board_area-->
			</div><!--//notice_area-->
		</div><!--//con_box-->
	</div><!-- .content -->

</form>	
</div>

<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

</body>
</html>

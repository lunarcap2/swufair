<% Option Explicit %>
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/common/common.asp"--> 
<!--#include virtual = "/inc/function/paging.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
<%
	' ������ ������ ��쿡�� ���� ���   
	If Request.Cookies(site_code & "WKADMIN")("admin_id")="" Then 
		Response.Write "<script language=javascript>"&_
			"alert('�ش� �޴��� ���� ���� ������ �����ϴ�.');"&_
			"location.href='/';"&_
			"</script>"
		response.End 
	End If
	
	Dim i, mode
	Dim mentor_no : mentor_no = request("mentor_no")
	Dim title, explain, mentoring_day, mentoring_time, img_logo, link_url, s_date, s_time, e_date, e_time, limit_cnt
	limit_cnt = 4

	If mentor_no <> "" Then
	ConnectDB DBCon, Application("DBInfo_FAIR")
		
		mode = "edit"

		Dim Param(0)
		Param(0) = makeparam("@MENTOR_NO",adInteger,adParamInput,4,mentor_no)

		Dim arrRs
		arrRs = arrGetRsSP(DBcon, "asp_������_�������_�󼼺�", Param, "", "")

		If isArray(arrRs) Then
			title			= arrRs(1, 0)
			explain			= arrRs(2, 0)
			mentoring_day	= arrRs(3, 0)
			mentoring_time	= arrRs(4, 0)
			img_logo		= arrRs(5, 0)
			link_url		= arrRs(6, 0)
			s_date			= arrRs(7, 0)
			s_time			= arrRs(8, 0)
			e_date			= arrRs(9, 0)
			e_time			= arrRs(10, 0)
			limit_cnt		= arrRs(11, 0)
		End If

	DisconnectDB DBCon

	End If
%>
<!--#include virtual = "/include/header/header.asp"-->
<script type="text/javascript">
	$(document).ready(function () {
		// ������� �ð�����
		var mentoring_time = "<%=mentoring_time%>";

		var arr	= new Array();
		arr		= mentoring_time.split(",");
		for (i = 0; i < arr.length; i++) {
			 $("input:checkbox[name=mentoring_time][value='"+arr[i]+"']").prop("checked",true);
		}	

	});
	
	function fn_submit() {

		if ($('#title').val() == '') {
			alert('������ �Է��� �ּ���.');
			$('#title').focus();
			return;
		}
		
		/*
		if ($('#explain').val() == '') {
			alert('�Ҽ��� �Է��� �ּ���.');
			$('#explain').focus();
			return;
		}
		*/

		if ($('#mentoring_day').val() == '') {
			alert('������� ���ڸ� �Է��� �ּ���.');
			$('#mentoring_day').focus();
			return;
		}

		if ($("input:checkbox[name='mentoring_time']").is(":checked") == false) {
			alert("������� �ð��� ������ �ּ���.");
			$("[name='mentoring_time']").focus();
			return;
		}

		if ($('#link_url').val() == '') {
			alert('Zoom �ּҸ� �Է��� �ּ���.');
			$('#link_url').focus();
			return;
		}

		if ($('#searchStartDate').val() == '') {
			alert('����û �Ⱓ�� �Է��� �ּ���.');
			$('#searchStartDate').focus();
			return;
		}

		if ($('#searchEndDate').val() == '') {
			alert('����û �Ⱓ�� �Է��� �ּ���.');
			$('#searchEndDate').focus();
			return;
		}

		if ($('#limit_cnt').val() == '') {
			alert('��û���� �ο��� ������ �ּ���.');
			$('#limit_cnt').focus();
			return;
		}		

		if ($("#mode").val() == "" && $('#img_logo').val() == '') {
			alert('�ΰ� �̹����� ÷�����ּ���');
			$('#img_logo').focus();
			return;
		}


		/*
		if ($('#mentoring_day').val() == '' || $('#mentoring_hour').val() == '' || $('#mentoring_min').val() == '') {
			alert('���丵 �Ͻø� ��� �Է��� �ּ���.');
			return;
		}
		
		if ($("#mode").val() == "" && $('#file_com_logo').val() == '') {
			alert('ȸ��ΰ� �̹����� ÷�����ּ���');
			$('#file_com_logo').focus();
			return;
		}
		*/

		document.frm.action = "./mentor_reg_proc.asp";
		document.frm.submit();
	}


	//���� ÷�� �̸�����
	function fn_load_img(obj) {
		var file_name = $(obj).val();
		$('#upload_name').val(file_name);
	}
	
	// ��ũ�׽�Ʈ
	function fn_chkUrl() {
		var link_url = $("#link_url").val().replace("http://","").replace("https://","");

		window.open("http://" + link_url);
	}


</script>
</head>

<body id="loginWrap">
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<!-- ������ -->
<form method="post" id="frm" name="frm" enctype="multipart/form-data">
<input type="hidden" id="mentor_no" name="mentor_no" value="<%=mentor_no%>">
<input type="hidden" id="mode" name="mode" value="<%=mode%>">

<div id="contents" class="admin">
	<div class="content">
		<div class="navi">
			<ul>
				<li><a href="#none;">Ȩ</a></li>
				<% If mode = "edit" Then %>
				<li><a href="#none;">������� ���� ���� ����</a></li>
				<% Else %>
				<li><a href="#none;">������� ���� ���� ���</a></li>
				<% End If %>
			</ul>
		</div>
		<div class="list_area view">
			<div class="tit">
				<% If mode = "edit" Then %>
				<h3>������� ���� ���� ����</h3>
				<% Else %>
				<h3>������� ���� ���� ���</h3>
				<% End If %>
			</div>
			<table class="tb">
				<colgroup>
					<col style="width:20%;">
					<col style="width:30%;">
					<col style="width:20%;">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th>����</th>
						<td colspan="3">
							<input type="text" class="txt" id="title" name="title" value="<%=title%>" placeholder="������ �Է��� �ּ���." style="width:100%;">
						</td>
					</tr>
					<tr>
						<th>�Ҽ�</th>
						<td colspan="3">
							<input type="text" class="txt" id="explain" name="explain" value="<%=explain%>" placeholder="�Ҽ��� �Է��� �ּ���." style="width:100%;">
						</td>
					</tr>
					<tr>
						<th>������� ����</th>
						<td colspan="3">
							<div class="datePick">
								<span>
									<input type="text" class="datepicker only" id="mentoring_day" name="mentoring_day" value="<%=mentoring_day%>" style="width:210px;">
									<button type="button" class="btncalendar dateclick">��¥����</button>
								</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>������� �ð�����</th>
						<td colspan="3" class="input_add">
							<div class="input_add_box">
								<% For i=7 To 14 %>
								<label class="checkbox" for="for<%=i%>">
									<input type="checkbox" class="chk" id="for<%=i%>" name="mentoring_time" value="<%=i%>" onclick="chkWorkStyleCnt(this);" <%If mentor_no="" Then%>checked<%End If%>>
									<span><%=getInterviewTime(i)%></span>
								</label>
								<% Next %>
							</div>
						</td>
					</tr>
					<tr>
						<th>Zoom �ּ�</th>
						<td colspan="3" class="input_add">
							<input type="text" class="txt" id="link_url" name="link_url" value="<%=link_url%>" placeholder="Zoom�ּҸ� �Է��� �ּ���." style="width:80%;">
							&nbsp;
							<a href="javascript:;" type="_blank" class="btn blue" onclick="fn_chkUrl(); return false;">��ũ �׽�Ʈ</a>
						</td>
					</tr>
					<tr>
						<th>����û �Ⱓ</th>
						<td  colspan="3">
							<div class="time_box">
								
								<div class="datePick">
									<span>
										<input type="text" class="datepicker two" id="searchStartDate" name="s_date" value="<%=s_date%>" style="width:210px;">
										<button type="button" class="btncalendar dateclick">��¥����</button>
									</span>
									<em>~</em>
									<span>
										<input type="text" class="datepicker two" id="searchEndDate" name="e_date" value="<%=e_date%>" style="width:210px;">
										<button type="button" class="btncalendar dateclick">��¥����</button>
									</span>
								</div>

								<span class="selectbox" style="width:210px;">
									<span class="">����</span>
									<select id="e_time" name="e_time" title="�ð�����">
										<option value="">����</option>
										<% For i=0 To 23 %>
										<option value="<%=i%>" <%If e_time = CStr(i) Then%>selected="selected"<%End If%>><%=i%>��</option>
										<% Next %>
									</select>
								</span>
								
							</div>
						</td>
					</tr>
					<tr>
						<th>��û�����ο�</th>
						<td  colspan="3">
							<span class="selectbox" style="width:210px;">
								<span class="">����</span>
								<select id="limit_cnt" name="limit_cnt" title="�����ο�����">
									<option value="">����</option>
									<% For i=1 To 4 %>
									<option value="<%=i%>" <%If limit_cnt = i Then%>selected="selected"<%End If%>><%=i%>��</option>
									<% Next %>
								</select>
							</span>
						</td>
					</tr>
					<tr>
						<th>�ΰ���</th>
						<td colspan="3">
							<div class="file_box">
								<input type="hidden" name="str_img_logo" value="<%=img_logo%>">
								<input type="text" class="upload_name" id="upload_name" placeholder="�ΰ� ����� �ּ���." disabled="disabled" style="width:430px;" value="<%=img_logo%>">
								<label for="img_logo">����ã��</label>
								<span>5 MB������ jpg���Ϸ� ����� �ּ���. (image size 300 X 100)</span>
								<input type="file" id="img_logo" name="img_logo" onchange="fn_load_img(this);">
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_area right">
				<a href="mentor_list.asp" class="btn list">���</button>
				<a href="javascript:" class="btn blue" onclick="fn_submit();">���� ����</button>
				<a href="javascript:history.back();" class="btn gray">���</button>
			</div>
		</div><!-- list_area view -->
	</div><!-- //content -->
</div><!-- //contents -->
</form>
<!--// ������ -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->
</body>	
</html>
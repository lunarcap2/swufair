<%
	Option Explicit
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
<%
	Call FN_LoginLimit("1")    '����ȸ���� ���ٰ���

	If Request.ServerVariables("HTTPS") = "on" Then 
		Response.redirect "http://"& Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("URL") 
	End If

	Dim i, ii, jj, strQuery, totalCnt
%>
<script type="text/javascript">
	function fn_apply_del(_gubun, _val) {

		var txtGubun;	
		switch (_gubun){
			case "1" :
				txtGubun = "�������";
				break;
			case "2" :
				txtGubun = "Ư��";
				break;
			default :
				txtGubun = "����";
		}	

		if (confirm("��û�Ͻ� "+txtGubun+"�� ����Ͻðڽ��ϱ�?")) {
			$('#apply_gubun').val(_gubun);
			$('#apply_no').val(_val);
			$('#frm').attr('action', '/my/proc_apply_del.asp');
			$('#frm').submit();
		}
	}
	
	//����
	function fn_apply_attend(_val) {
		window.open(_val);
	}
	
	//������������ �˾�
	function fn_pop_question(_obj, _mento_val, _question_val) {

		var _mentor_no = _mento_val;
		var _question_idx = _question_val;
		$('#pop_question_idx').val(_question_val);

		$.ajax({
			url: "./inc_pop_question_view.asp",
			type: "POST",
			dataType: "html",
			data: ({
				"mentor_no": _mentor_no,
				"question_idx": _question_idx,
			}),
			success: function (data) {
				view_layer(2);
				$('#pop_area_question_view').html(data);
			},
			error: function (req, status, err) {
				alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
			}
		});


		/*
		var list_div = $(_obj).parents("#question_list");
		var com = $(list_div).find("#quest_mentor_com").text();
		var name = $(list_div).find("#quest_mentor_name").text();
		var day = $(list_div).find("#quest_mentor_day").text();
		var q_cont = $(_obj).parents("tr").find(".subject").text();

		var file1 = $(_obj).parents("tr").find(".subject").text();
		var file2 = $(_obj).parents("tr").find(".subject").text();

		
		$('#pop_question_idx').val(_val);
		$('#pop_question_com').text(com);
		$('#pop_question_name').text(name);
		$('#pop_question_day').text(day);
		$('#pop_question_cont').text(q_cont);
		*/
	}

	function fn_question_mod() {
		$('#frm_pop_question').attr('action', '/my/proc_question_mod.asp');
		$('#frm_pop_question').submit();
	}

	function fn_load_img(obj) {
		var file_name = $(obj).val();
		$(obj).parent().find(".upload_name").val(file_name);
	}

</script>
</head>

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<form id="frm" name="frm" method="post">
	<input type="hidden" id="apply_gubun" name="apply_gubun" value="" />
	<input type="hidden" id="apply_no" name="apply_no" value="" />
	<input type="hidden" id="question_no" name="question_no" value="" />
	<input type="hidden" id="question_cont" name="question_cont" value="" />
</form>

<!-- ���� -->
<div id="contents" class="main">
	<div class="content">
		<div class="content_area">
			<div class="my_area">
				
				<!--My Info-->
				<!--#include virtual = "/include/my/myInfo.asp"-->
				
				<!--������� ��û��Ȳ-->
				<!--#include virtual = "/include/my/consulting.asp"-->

				<!--Ư�� ��û��Ȳ-->
				<!--#include virtual = "/include/my/lcture.asp"-->

			</div><!--my_area -->
		</div>
	</div><!-- .content -->
</div>
<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

<!--#include file = "./inc_popup.asp"-->

</body>	
</html>
var _frm1 = null;
$(document).ready(function () {
	_frm1 = document.frm1;
});


//�̷¼� ���/����
function fn_resume_save() {
	//�������̼� üũ
	if (fn_chk_validate()) {
		fn_resume_save_chkdata();
		_frm1.resumeIsComplete.value = "1";
		_frm1.action = '/my/resume/resume_insert_renew.asp';
		_frm1.target = "_self";
		_frm1.submit();
	}
}

//�̷¼� �ӽ�����
function fn_resume_save_imsi() {
	//�������̼� üũ
	if (fn_chk_validate()) {
		fn_resume_save_chkdata();
		_frm1.resumeIsComplete.value = "2";
		_frm1.action = '/my/resume/resume_insert_renew.asp';
		_frm1.target = "procFrame";
		_frm1.submit();
	}
}

function fn_resume_save_preview() {
	//�������̼� üũ
	if (fn_chk_validate()) {
		fn_resume_save_chkdata();
		_frm1.resumeIsComplete.value = "3";
		_frm1.action = '/my/resume/resume_insert_renew.asp';
		_frm1.target = "procFrame";
		_frm1.submit();
	}
}
function fn_resume_preview() {
	_frm1.action = '/my/resume/resume_preview.asp';
	_frm1.target = "_blank";
	_frm1.submit();
}


function fn_validate_chkdate(obj) {
	temp_value = obj.value.toString();
	temp_length = obj.value.replace(".", "").length;
	
	if (temp_length > 0 && temp_length != 6) {
		alert("��ȿ���� ���� ��¥�Դϴ�.");
		obj.focus();
		return false;
	}
	
	if (temp_length > 0) {
		oDate = new Date();
		//oDate.setFullYear(temp_value.split(".")[0]);
		//oDate.setMonth(parseInt(temp_value.split(".")[1]) - 1);

		var year = temp_value.split(".")[0];
		var month = parseInt(temp_value.split(".")[1]);

		//if( oDate.getFullYear() != temp_value.split(".")[0] || oDate.getMonth() + 1 != temp_value.split(".")[1] ) {
		if (year < oDate.getFullYear() -100 || year > oDate.getFullYear() +100 || month < 1 || month > 12) {
			alert("��ȿ���� ���� ��¥�Դϴ�.");
			obj.focus();
			return false;
		}
	}
}

function fn_chk_validate() {

	if (_frm1.userName.value == '') {
		alert('�̸��� �Է����ּ���.');
		_frm1.userName.focus();
		return false;
	}
	if (_frm1.user_cell1.value == '' || _frm1.user_cell2.value == '' || _frm1.user_cell3.value == '') {
		alert('����ó�� �Է����ּ���.');
		_frm1.user_cell.focus();
		return false;
	}
	if (_frm1.birthYY.value == '' || _frm1.birthMM.value == '' || _frm1.birthDD.value == '') {
		alert('��������� �Է����ּ���.');
		_frm1.birth.focus();
		return false;
	}
	else {
		//�̼����� 18�� üũ (�������� selectbox�� 19����� �����̶�)
		var date = new Date();
		var birth_year

		birth_year = date.getFullYear() - 18
		
		if (birth_year < _frm1.birthYY.value) {
			alert("��� �ش� ���ɿ� ���� �ʽ��ϴ�.\n�ٽ� �Է����ּ���.");
			_frm1.birth.focus();
			return false;
		}
	}

	if (_frm1.email1.value == '' || _frm1.email2.value == '') {
		alert('E-mail�� �Է����ּ���.');
		_frm1.email.focus();
		return false;
	}
	if (_frm1.address.value == '') {
		alert('�ּҸ� �Է����ּ���.');
		_frm1.address.focus();
		return false;
	}

	//�з� ���г�� üũ
	if (_frm1.univ_sdate != null)
	{
		if (_frm1.univ_sdate.length > 0) {
			for (var i = 0; i < _frm1.univ_sdate.length; i++) {
				if (fn_validate_chkdate(_frm1.univ_sdate[i]) == false) {
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.univ_sdate) == false) {
				return false;
			}
		}
	}
	//�з� ������� üũ
	if (_frm1.univ_edate != null)
	{
		if (_frm1.univ_edate.length > 0) {
			for (var i = 0; i < _frm1.univ_edate.length; i++) {
				if (fn_validate_chkdate(_frm1.univ_edate[i]) == false) {
					return false;
				}
				if (_frm1.univ_edate[i].value != "" && _frm1.univ_sdate[i].value > _frm1.univ_edate[i].value) {
					alert("�з� �������� �����Ϻ��� ���� �� �����ϴ�.");
					_frm1.univ_edate[i].focus();
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.univ_edate) == false) {
				return false;
			}
			if (_frm1.univ_edate.value != "" && _frm1.univ_sdate.value > _frm1.univ_edate.value) {
				alert("�з� �������� �����Ϻ��� ���� �� �����ϴ�.");
				_frm1.univ_edate.focus();
				return false;
			}
		}
	}


	//��� �Ի��� üũ
	if (_frm1.experience_sdate != null)
	{
		if (_frm1.experience_sdate.length > 0) {
			for (var i = 0; i < _frm1.experience_sdate.length; i++) {
				if (fn_validate_chkdate(_frm1.experience_sdate[i]) == false) {
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.experience_sdate) == false) {
				return false;
			}
		}
	}
	//��� ����� üũ
	if (_frm1.experience_edate != null)
	{
		if (_frm1.experience_edate.length > 0) {
			for (var i = 0; i < _frm1.experience_edate.length; i++) {
				if (fn_validate_chkdate(_frm1.experience_edate[i]) == false) {
					return false;
				}
				if (_frm1.experience_edate[i].value != "" && _frm1.experience_sdate[i].value > _frm1.experience_edate[i].value) {
					alert("��� ������� �Ի��Ϻ��� ���� �� �����ϴ�.");
					_frm1.experience_edate[i].focus();
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.experience_edate) == false) {
				return false;
			}
			if (_frm1.experience_edate.value != "" && _frm1.experience_sdate.value > _frm1.experience_edate.value) {
				alert("��� ������� �Ի��Ϻ��� ���� �� �����ϴ�.");
				_frm1.experience_edate.focus();
				return false;
			}
		}
	}


	//����,���Ȱ�� ������ üũ
	if (_frm1.rac_sdate != null)
	{
		if (_frm1.rac_sdate.length > 0) {
			for (var i = 0; i < _frm1.rac_sdate.length; i++) {
				if (fn_validate_chkdate(_frm1.rac_sdate[i]) == false) {
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.rac_sdate) == false) {
				return false;
			}
		}
	}
	//����,���Ȱ�� ������ üũ
	if (_frm1.rac_edate != null)
	{
		if (_frm1.rac_edate.length > 0) {
			for (var i = 0; i < _frm1.rac_edate.length; i++) {
				if (fn_validate_chkdate(_frm1.rac_edate[i]) == false) {
					return false;
				}
				if (_frm1.rac_edate[i].value != "" && _frm1.rac_sdate[i].value > _frm1.rac_edate[i].value) {
					alert("����,���Ȱ�� �������� �����Ϻ��� ���� �� �����ϴ�.");
					_frm1.rac_edate[i].focus();
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.rac_edate) == false) {
				return false;
			}
			if (_frm1.rac_edate.value != "" && _frm1.rac_sdate.value > _frm1.rac_edate.value) {
				alert("����,���Ȱ�� �������� �����Ϻ��� ���� �� �����ϴ�.");
				_frm1.rac_edate.focus();
				return false;
			}
		}
	}


	//�ܱ��� �������� üũ
	if (_frm1.language_date != null)
	{	
		if (_frm1.language_date.length > 0) {
			for (var i = 0; i < _frm1.language_date.length; i++) {
				if (fn_validate_chkdate(_frm1.language_date[i]) == false) {
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.language_date) == false) {
				return false;
			}
		}
	}

	//�ڰ��� ������� üũ
	if (_frm1.license_date != null)
	{	
		if (_frm1.license_date.length > 0) {
			for (var i = 0; i < _frm1.license_date.length; i++) {
				if (fn_validate_chkdate(_frm1.license_date[i]) == false) {
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.license_date) == false) {
				return false;
			}
		}
	}

	//���� �������� üũ
	if (_frm1.prize_date != null)
	{	
		if (_frm1.prize_date.length > 0) {
			for (var i = 0; i < _frm1.prize_date.length; i++) {
				if (fn_validate_chkdate(_frm1.prize_date[i]) == false) {
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.prize_date) == false) {
				return false;
			}
		}
	}


	//���� ������ üũ
	if (_frm1.academy_sdate != null)
	{
		if (_frm1.academy_sdate.length > 0) {
			for (var i = 0; i < _frm1.academy_sdate.length; i++) {
				if (fn_validate_chkdate(_frm1.academy_sdate[i]) == false) {
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.academy_sdate) == false) {
				return false;
			}
		}
	}
	//���� ������ üũ
	if (_frm1.academy_edate != null)
	{
		if (_frm1.academy_edate.length > 0) {
			for (var i = 0; i < _frm1.academy_edate.length; i++) {
				if (fn_validate_chkdate(_frm1.academy_edate[i]) == false) {
					return false;
				}
				if (_frm1.academy_edate[i].value != "" && _frm1.academy_sdate[i].value > _frm1.academy_edate[i].value) {
					alert("���� �������� �����Ϻ��� ���� �� �����ϴ�.");
					_frm1.academy_edate[i].focus();
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.academy_edate) == false) {
				return false;
			}
			if (_frm1.academy_edate.value != "" && _frm1.academy_sdate.value > _frm1.academy_edate.value) {
				alert("���� �������� �����Ϻ��� ���� �� �����ϴ�.");
				_frm1.academy_edate.focus();
				return false;
			}
		}
	}


	//�ؿܰ��� ������ üũ
	if (_frm1.abroad_sdate != null)
	{
		if (_frm1.abroad_sdate.length > 0) {
			for (var i = 0; i < _frm1.abroad_sdate.length; i++) {
				if (fn_validate_chkdate(_frm1.abroad_sdate[i]) == false) {
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.abroad_sdate) == false) {
				return false;
			}
		}
	}
	//�ؿܰ��� ������ üũ
	if (_frm1.abroad_edate != null)
	{
		if (_frm1.abroad_edate.length > 0) {
			for (var i = 0; i < _frm1.abroad_edate.length; i++) {
				if (fn_validate_chkdate(_frm1.abroad_edate[i]) == false) {
					return false;
				}
				if (_frm1.abroad_edate[i].value != "" && _frm1.abroad_sdate[i].value > _frm1.abroad_edate[i].value) {
					alert("�ؿܰ��� �������� �����Ϻ��� ���� �� �����ϴ�.");
					_frm1.abroad_edate[i].focus();
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.abroad_edate) == false) {
				return false;
			}
			if (_frm1.abroad_edate.value != "" && _frm1.abroad_sdate.value > _frm1.abroad_edate.value) {
				alert("�ؿܰ��� �������� �����Ϻ��� ���� �� �����ϴ�.");
				_frm1.abroad_edate.focus();
				return false;
			}
		}
	}


	//���� �Դ��� üũ
	if (_frm1.military_sdate != null)
	{
		if (_frm1.military_sdate.length > 0) {
			for (var i = 0; i < _frm1.military_sdate.length; i++) {
				if (fn_validate_chkdate(_frm1.military_sdate[i]) == false) {
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.military_sdate) == false) {
				return false;
			}
		}
	}
	//���� ������ üũ
	if (_frm1.military_edate != null)
	{
		if (_frm1.military_edate.length > 0) {
			for (var i = 0; i < _frm1.military_edate.length; i++) {
				if (fn_validate_chkdate(_frm1.military_edate[i]) == false) {
					return false;
				}
				if (_frm1.military_edate[i].value != "" && _frm1.military_sdate[i].value > _frm1.military_edate[i].value) {
					alert("���� �Դ����� �����Ϻ��� ���� �� �����ϴ�.");
					_frm1.military_edate[i].focus();
					return false;
				}
			}
		} else {
			if (fn_validate_chkdate(_frm1.military_edate) == false) {
				return false;
			}
			if (_frm1.military_edate.value != "" && _frm1.military_sdate.value > _frm1.military_edate.value) {
				alert("���� �Դ����� �����Ϻ��� ���� �� �����ϴ�.");
				_frm1.military_edate.focus();
				return false;
			}
		}
	}


	return true;
}

function fn_resume_save_chkdata() {
	//���ּ� ����
	if (_frm1.address_dtl.value != "") {
		_frm1.address.value = _frm1.address.value.split(" / ")[0] + " / " + _frm1.address_dtl.value;
	}
	
	//�ְ��з��ڵ� ����(�з»��� �з±����ڵ� ������)
	if (_frm1.univ_kind) {
		_frm1.final_scholar.value = _frm1.univ_kind.value;

		var univ_kind = 0;
		for (var i = 0; i < _frm1.univ_kind.length; i++) {
			if (_frm1.univ_kind[i].value > univ_kind) {
				univ_kind = _frm1.univ_kind[i].value;
			}
			_frm1.final_scholar.value = univ_kind;
		}
	}
}

//�̷¼� (�з�_�б���, ���_ȸ���, �ڰ�����) Ű���� �˻�
function fn_kwSearchItem(obj, _gubun) {
	/*
	���� ���� ��� ã��
	$("������").prev()
	$("������").prevAll("������");

	���� ���� ��� ã��
	$("������").next()
	$("������").nextAll("������");
	*/

	var _kw = $(obj).val();
	var _result_obj = $(obj).attr("id");

	if (_kw == "") {
		return;
	}

	$.ajax({
		url: "/my/resume/comm/search_result_school.asp",
		type: "POST",
		dataType: "text",
//		contentType: 'application/x-www-form-urlencoded; charset=euc-kr',
		data: ({
			"kw": escape(_kw),
			"sGubun": _gubun,
			"idx": 0,
			"result_obj_id": _result_obj
		}),
		success: function (data) {
			$(obj).nextAll("#id_result_box").html(data);
		},
		error: function (req, status, err) {
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});
	
	document.charset = "euc-kr";
	/*
	$.get("/my/resume/comm/search_result_school.asp", { "kw": _kw, "sGubun": _gubun, "idx": 0, "result_obj_id": _result_obj }, function (data) {
		$(obj).nextAll("#id_result_box").html(data);
	});
	*/
}

//�ڵ�
function textIn(obj, text, result_obj) {
	/*
	�ٷ� ���� �θ�
	$("������").parent()

	��� �θ� ã��
	$("������").parents() ��� �θ�

	��� �θ� �� �����ڿ� �ش��ϴ� �θ� ã��
	$("������").parents("������")

	Ư�� �ڽĳ�� ã��
	$("������").children("������")
	*/

	$(obj).parents(".search_box").children("#" + result_obj).val(text);
	$(obj).parents('.result_box').hide();
}

// a�±����� ���ùڽ� ���ð� ����
function fn_sel_value_set(obj, set_name, get_value) {
	$(obj).parents(".ib_m_box").children("#" + set_name).val(get_value);
}

function fn_mod_date_update(_rid) {

	$.ajax({
		url: "/my/resume/resume_date_update.asp",
		type: "POST",
		dataType: "text",
		data: ({
			"rid": _rid
		}),
		success: function (data) {
			alert("�̷¼��� ���ó�¥�� ������Ʈ �Ͽ����ϴ�.");
		},
		error: function (req, status, err) {
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});

}



function printIframe(id) { //�μ��ϱ� 2015-10-21 skydown@career.co.kr
	
	var agent = navigator.userAgent.toLowerCase();

	if(agent.indexOf("chrome") != -1 || agent.indexOf("safari") != -1 || agent.indexOf("chrome") != -1 || agent.indexOf("firefox") != -1) {
		var iframe = document.frames ? document.frames[id] : document.getElementById(id);

		var ifWin = iframe.contentWindow || iframe;
		iframe.focus();
		ifWin.printPage();
		return false;
	}

	if(agent.indexOf("msie") != -1 && navigator.appName == "Netscape"){
		window.print();
		return false;
	} else {
		var iframe = document.frames ? document.frames[id] : document.getElementById(id);

		var ifWin = iframe.contentWindow || iframe;
		iframe.focus();
		ifWin.printPage();
		return false;
	}

} //�μ��ϱ�



function printIframe_test(id) {
	
	var agent = navigator.userAgent.toLowerCase();

	if(agent.indexOf("chrome") != -1 || agent.indexOf("safari") != -1 || agent.indexOf("chrome") != -1 || agent.indexOf("firefox") != -1) {
		var iframe = document.frames ? document.frames[id] : document.getElementById(id);

		var ifWin = iframe.contentWindow || iframe;
		iframe.focus();
		ifWin.leehoPreview();
		return false;
	}

	if(agent.indexOf("msie") != -1 && navigator.appName == "Netscape"){
		window.print();
		return false;
	} else {
		var iframe = document.frames ? document.frames[id] : document.getElementById(id);

		var ifWin = iframe.contentWindow || iframe;
		iframe.focus();
		ifWin.leehoPreview();
		return false;
	}

} //�μ��ϱ�
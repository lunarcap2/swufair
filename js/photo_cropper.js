/*
*	get the information of the default resume
*/
function fn_get_info(uid) {
	uid = uid || $('#uid').val();
	if(uid=='') {
		alert('�� ���񽺸� �̿��ϱ� ���ؼ��� ����ȸ�� �α����� �ʿ��մϴ�.\n�α��� �� �̿��� �ֽñ� �ٶ��ϴ�.');
		fn_login_redirect();
		return;
	} else {
		$.get("/wwwconf/include/tools/ajax_resumeinfo_get.asp?dummy="+Math.random()*99999+"&uid=" +uid, function(data) {
			var json = eval( "(" + data + ")" );
			if(json.ret_val>0 && json.info[0].rsm_idx!='') {	// �⺻�̷¼� ����
				$("#rid").val(json.info[0].rsm_idx);
				$("#rstep").val(json.info[0].rsm_step);
			} else {
				$("#rid").val("0");
			}
		});
	}
}

/*
*	apply the cropped image to user's photo in the default resume
*/
function fn_resume_apply() {
	var agree_chk = $("#daum_agree").val() || '-1';
	if(!$_isDaum) {
		agree_chk = "1";
	}
	
	if(agree_chk=="-1") {
		alert('�� ���񽺸� �̿��ϱ� ���ؼ��� ����ȸ�� �α����� �ʿ��մϴ�.\n�α��� �� �̿��� �ֽñ� �ٶ��ϴ�.');
		fn_login_redirect();
		return;
	} else if(agree_chk=="0") {
		alert('���� �������� �������Ǹ� ���ֽñ� �ٶ��ϴ�.');
		var newWin = window.open("/my/");
		if(newWin==null) {
			alert('�˾��� ���ܵǾ����ϴ�.\n�˾������� �����ϰ� �ٽ� �õ����ֽñ� �ٶ��ϴ�.');
		}
		return;
	} else if(agree_chk=="1") {
		
		if(document.sendForm.oldimgpath.value.trim()=='') {
			alert('���� ����÷�θ� ���ֽʽÿ�.');
			return;
		}

		if (document.sendForm.x1.value.trim()=='NaN') {
			alert("�߸� ÷�εǾ����ϴ�. �ٽýõ��� �ֽñ� �ٶ��ϴ�.");
			window.close();
			return;
		}
		
		if( ($("#rid").val()=='' || $("#rstep").val()=='') && document.location.href.indexOf('/my/resume_list.asp') == -1) {
			if($("#rid").val()=='0') {
				if(confirm("���� ����Ͻ� �̷¼��� �����ϴ�.\n�̷¼��� ���� ����Ͻðڽ��ϱ�?")) {
					window.open("/my/resume/resume_regist.asp");
				}
				return;
			} else {
				alert('�� ���񽺸� �̿��ϱ� ���ؼ��� ����ȸ�� �α����� �ʿ��մϴ�.\n�α��� �� �̿��� �ֽñ� �ٶ��ϴ�.');
				fn_login_redirect();
				return;
			}
		} else {
			var apply_bool = false;
			if($('#cropWidth').val()=='136' && $('#cropHeight').val()=='177') {
				apply_bool = confirm('�����Ͻ� �������� �̷¼� ������ ����˴ϴ�.\n�̷¼��� ���� �Ͻðڽ��ϱ�?');
			} else {
				apply_bool = confirm('���� ȸ���Բ��� ����Ͻ� ������ ' + $('#cropWidth').val() + '*' + $('#cropHeight').val() + '�Դϴ�.\n'
					+ ($_isDaum ? 'Daum�������' : 'Ŀ����')
					+ '�� �⺻ �̷¼� ����ũ��� 95*120�̸�,\n����� ������ ��, ������¡ ó�� �˴ϴ�.\n�̷¼� ������ �����Ͻðڽ��ϱ�?');
			}
			
			if(apply_bool) {
				var formobj = document.sendForm;
				
				if(formobj.oldimgpath.value.trim()=='') {
					alert('���� ����÷�θ� ���ֽʽÿ�.');
					return;
				}
				
				if(formobj.x1.value=='' || formobj.y1.value=='' || formobj.x2.value=='' || formobj.y2.value=='' || formobj.orgnWidth.value=='' || formobj.orgnHeight.value=='' 
					|| formobj.dispWidth.value=='' || formobj.dispHeight.value=='' || formobj.cropWidth.value=='' || formobj.cropHeight.value=='' || formobj.oldimgpath.value=='') {
					alert('�̷¼��� ������ ������ �������� �ʽ��ϴ�.\n���� ���� ���� �� �����Ͽ� �ֽñ� �ٶ��ϴ�.');
					return;
				} else {
					var orgn_action = formobj.action;
					var orgn_target = formobj.arget;
					formobj.action = $_cropDomain + "/my/resume/thumb_resume_apply.asp";
					formobj.target = "procFrame";
					
					$('#dummy').val( Math.random()*99999 );
					formobj.submit();
					formobj.action = orgn_action;
					formobj.target = orgn_target;
				}
			}
		}
	}
}

/*
*	after applying the cropped image
*/
function fn_resume_apply_after(targetimgpath) {
	console.log(targetimgpath);
	targetimgpath = targetimgpath || '';
	if( ($("#rid").val()=='' || $("#rstep").val()=='') && document.location.href.indexOf('/my/resume_list.asp') == -1) {
		alert('���� ����Ͻ� �̷¼��� �����ϴ�.');
	} else {
		// active view button for default resume link
		if($('#apply_notice_area').length>0) {	// from tools' page
			var html = '<p class="f_line"><a href="/my/resume/resume_view.asp?rid=' + $('#rid').val() + '" target="_blank"><img src="http://image.career.co.kr/career_new/tools/btn_resume_save02.gif" alt="�⺻�̷¼� ���� Ȯ���ϱ�" /></a></p>\n'
				+ '<p><img src="http://image.career.co.kr/career_new/tools/txt_resume_save02.gif" alt="�⺻�̷¼��� ������ �Ϸ�Ǿ����ϴ�. �⺻�̷¼� ���� Ȯ���ϱ� �� �����ø�, Ȯ���� �����մϴ�." /></p>';
			$('#apply_notice_area').html(html);
			
			/*
			// form reset
			document.uploadForm.reset();
			document.sendForm.reset();
			
			// initialize all descriptions and informations
			$(".txt_photo").show();
			$('.photo_view').html('');
			html = '<p style="width:95px;height:120px;overflow:hidden;"><img id="previewimg" src="http://image.career.co.kr/career_new/tools/img_edit_photo.gif" title="���� ������ �����ϼ���" alt="�̷¼� ������ ����� ����� �¿��մϴ�" /></p>';
			$('.edit_photo').html(html);
			*/
			
			alert('�̷¼��� ����Ǿ����ϴ�.');
		} else {	// from popup page
			if(opener!=null && typeof(opener)!='unknown') {
				alert('�̷¼��� ����Ǿ����ϴ�.');
				self.close();
				opener.location.reload();

			} else {
				alert('�̷¼��� ����Ǿ����ϴ�.');
				document.location.href = window.location.href;
			}
		}
	}
}

/*
*	save the thumbnail image to local machine
*/
function fn_client_save() {
	var formobj = document.sendForm;
	
	if(formobj.oldimgpath.value.trim()=='') {
		alert('���� ����÷�θ� ���ֽʽÿ�.');
		return;
	}
	
	if(formobj.x1.value=='' || formobj.y1.value=='' || formobj.x2.value=='' || formobj.y2.value=='' || formobj.orgnWidth.value=='' || formobj.orgnHeight.value=='' 
		|| formobj.dispWidth.value=='' || formobj.dispHeight.value=='' || formobj.cropWidth.value=='' || formobj.cropHeight.value=='' || formobj.oldimgpath.value=='') {
		alert('PC�� ������ ������ �������� �ʽ��ϴ�.\n���� ���� ���� �� �����Ͽ� �ֽñ� �ٶ��ϴ�.');
		return;
	} else {
		$('#dummy').val( Math.random()*99999 );
		formobj.submit();
	}
}


/*
*	upload image file
*/
function fn_temp_upload(formobj) {
	formobj = formobj || document.uploadForm;
	
	var filepath = formobj.uploadFile.value;
	var validate_str = /\.(gif|jpg|jpeg)$/gi;
	
	if(filepath.trim()=='') {
		alert('����÷�θ� ���ֽʽÿ�.');
		return;
	}
	
	if(validate_str.test(filepath)) {
		$('#dummy').val( Math.random()*99999 );
		formobj.submit();
	} else {
		alert('���������� jpg, gif�� ���ε尡 �����մϴ�.');
		return;
	}
}

var $_jcrop_api;
var $_w, $_h;
/*
*	set the new image
*/
function fn_set_img(imgpath) {
	try {
		$(".photo_view").children().remove();
		if($('#sz01').length>0)	$('#sz01').attr("checked", true);
		
		var img_width, img_height, limit_width, limit_height;
		var img = new Image();
		img.id = "orgimg";
		img.src = imgpath;
		
		limit_width = $_isPopup ? 280 : 280;
		
		var YYYY,MM;
		var date = new Date();
		YYYY = date.getFullYear();
		MM = date.getMonth() + 1; MM = (MM < 10) ? "0" + MM : MM;

		$(img).load(function() {
			$(this).appendTo(".photo_view");
			
			img_width = $("#orgimg").css("width").replace("px","");
			img_height = $("#orgimg").css("height").replace("px","");
			
			$("#orgnWidth").val(img_width);
			$("#orgnHeight").val(img_height);
			
			img_height = (img_width > limit_width) ? Math.round(limit_width/img_width*img_height) : img_height;
			img_width = (img_width > limit_width) ? limit_width : img_width;
			
			this.width = img_width;
			this.height = img_height;
			
			$("#dispWidth").val(img_width);
			$("#dispHeight").val(img_height);

			$("#oldimgpath").val(imgpath.replace($_cropDomain + '/files/resume/' + YYYY + MM + '/',''));

			fn_init_crop();
			
			$(".txt_photo").hide();
			//if($('.letter_txt').length>0)	$('.letter_txt').show();

			// .edit_photo p img
			
			$("#previewimg").attr("src",imgpath).attr("alt","�̷¼��� ����").css({
				width : img_width+'px',
				height : img_height+'px'
			});

			$(".view_photo").hide();
			
			//alert(imgpath);
			
			// active apply button
			var html = '<p class="f_line"><span><img src="http://image.career.co.kr/career_new/tools/t_photo_apply.gif" alt="��������" /></span>';
			if($_isDaum) {
				html += '<a href="#" onclick="fn_resume_apply();return false;"><img src="http://image.career.co.kr/career_new/tools/btn_resume_save_d.gif" alt="��Daum������� �̷¼��� �����ϱ�" /></a></p>\n'
					+ '<p><img src="http://image.career.co.kr/career_new/tools/txt_resume_save_d.gif" alt="����ȸ������ �α��� �Ͻð�, �ϴ��� ��Daum������� �̷¼��� �����ϱ⡱�� �����ø�, �̷¼��� ����� �˴ϴ�" /></p>';
			} else {
				html += '<a href="#" onclick="fn_resume_apply();return false;"><img src="http://image.career.co.kr/career_new/tools/btn_resume_save.gif" alt="Ŀ���� �̷¼��� �����ϱ�" /></a></p>\n'
					+ '<p><img src="http://image.career.co.kr/career_new/tools/txt_resume_save.gif" alt="����ȸ������ �α��� �Ͻð�, �ϴ��� ��Ŀ���� �̷¼��� �����ϱ⡱�� �����ø�, �̷¼��� ����� �˴ϴ�" /></p>';
			}
			if($('#apply_notice_area').length>0)	$('#apply_notice_area').html(html);
			
			document.uploadForm.reset();
			
		});
	} catch(e) { alert(e.description); }
}

/*
*	reformat crop area
*/
function fn_reselect(w,h,sgb) {
	if($_jcrop_api) {
		$_jcrop_api.destroy();
		fn_init_crop(w,h);
		//document.getElementById("sitegb").innerHTML = sgb;
	} else {
		alert('���� ������ ������ �÷��ֽʽÿ�.');
		return;
	}
}

/*
*	input crop size directly
*/
function fn_reselect_chk() {
	if($_jcrop_api) {
		if(fn_chk_numeric($('#chng_width')) && fn_chk_numeric($('#chng_height'))) {
			if($('#chng_width').val()>150) {
				alert('���� 150�ȼ����� ������ �����մϴ�.');
				$('#chng_width').val("150");
			}
			if($('#chng_height').val()>200) {
				alert('���� 200�ȼ����� ������ �����մϴ�.');
				$('#chng_height').val("200");
			}
			fn_reselect($('#chng_width').val(),$('#chng_height').val());
		}
		$("input[name^=sz]").each(function() {
			$(this).checked = false;
		});
		return true;
	} else {
		alert('���� ������ ������ �÷��ֽʽÿ�.');
		return false;
	}
}

/*
*	initialize crop area
*/
function fn_init_crop(w,h) {
	$_w = w || 136;
	$_h = h || 177;
	var ratio = (Math.round($_w/$_h/.01)*.01);
	
	var dw, dh , nx, ny;
	dw = $('#dispWidth').val();
	dh = $('#dispHeight').val();
	dw = (dw=='') ? 0 : parseInt(dw);
	dh = (dh=='') ? 0 : parseInt(dh);
	
	nx = parseInt(Math.floor(dw/2 - $_w/2));
	ny = parseInt(Math.floor(dh/2 - $_h/2));
	nx = (nx<0) ? 0 : nx;
	ny = (ny<0) ? 0 : ny;
	
	$("#cropWidth").val($_w);
	$("#cropHeight").val($_h);
	$('#chng_width').val($_w);
	$('#chng_height').val($_h);
	
	$(".edit_photo div").css("width",$_w+"px").css("height",$_h+"px").parent().css("width",$_w+"px").css("height",$_h+"px");
	
	$_jcrop_api = $.Jcrop('.photo_view img', {
		onChange: fn_preview,
		onSelect: fn_preview,
		aspectRatio: ratio,
		allowSelect: false,
		setSelect : [nx,ny,($_w+nx),($_h+ny)]
	});
	$_jcrop_api.setSelect([nx,ny,($_w+nx),($_h+ny)]);
	
	fn_resize_arrow();
}

// Our simple event handler, called from onChange and onSelect
// event handlers, as per the Jcrop invocation above
function fn_preview(coords){
	var img_width, img_height;
	img_width = $("#dispWidth").val();
	img_height = $("#dispHeight").val();
	
	if (parseInt(coords.w) > 0)	{
		var rx = $_w / coords.w;
		var ry = $_h / coords.h;

		$('#previewimg').css({
			width: Math.round(rx * img_width) + 'px',
			height: Math.round(ry * img_height) + 'px',
			marginLeft: '-' + Math.round(rx * coords.x) + 'px',
			marginTop: '-' + Math.round(ry * coords.y) + 'px'
		});
	}
	
	$("#x1").val(coords.x);
	$("#y1").val(coords.y);
	$("#x2").val(coords.x2);
	$("#y2").val(coords.y2);
	// $("#cropWidth").val(coords.w);
	// $("#cropHeight").val(coords.h);
}

/*
*	line up the arrow icon
*/
function fn_resize_arrow() {
	//if($('.freesize').length > 0) {
		var thumb_width_def = 136;
		var thumb_width_cur = parseInt($('#cropWidth').val());
		var arrow_width_def = 126;
		var arrow_width_new;
		
		arrow_width_new = 126 - (thumb_width_cur - thumb_width_def);
		$('.freesize').css({
			width : arrow_width_new + 'px'
		});
	//}
}

/*
*	validate the input field for only number
*/
function fn_chk_numeric(obj) {
	var str = $(obj).val();
	var var_normalize = /[^0-9]/gi; //���Խ�
	
	if (var_normalize.test(str)) {
		alert("���ڸ� �Է��Ͻ� �� �ֽ��ϴ�.");
		$(obj).val(str.replace(var_normalize,""));
		return false;
	} else {
		return true;
	}
}
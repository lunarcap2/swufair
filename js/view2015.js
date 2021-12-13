var disableFnc, selectboxFnc, inputFnc, tooltipFnc, qnaNotiFnc;
(function($) {
    $(function() {
        $(document).ready(function() {
            if ($('#social-id').length > 0) socialFnc(); //sns�����ϱ�
            if ($('input.txt').length > 0) inputFnc();//��ǲ�ڽ�
            //if ($('input.value, textarea.area').length > 0) $('input.value, textarea.area').check();//��ǲ�ؽ�Ʈ üũ
            if ($('.requestAnswer a').length > 0) tooltipFnc();//������ Q&A
            selectboxFnc();//����Ʈ�ڽ�
        }); //ready
    }); //$
})(jQuery);

function socialFnc() { //sns�����ϱ�
    $("#social-id .btn").click(function() {
        $("#social-id .btn").hide();
        $("#social-id .opner").fadeIn(200).removeClass("break")
    })
    $("#social-id .close").click(function() {
        $("#social-id .btn").show();
        $("#social-id .opner").fadeOut(200).addClass("break")

    })
    $(window).scroll(function() {
        if ($('#social-id .opner').hasClass("break")) {
            return false;
        } else {
            if ($(window).scrollTop() == $(document).height() - $(window).height()) {
                $("#social-id .btn").show();
                $("#social-id .opner").fadeOut(200)
            } else {
                $("#social-id .btn").hide();
                $("#social-id .opner").fadeIn(200)
            }
        }
    });
} //sns�����ϱ�

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

function addLoadEvent(func) { // �ߺ� �ε� ó��
    var oldonload = window.onload;
    if (typeof window.onload != 'function') {
        if (document.all && !document.querySelector) { //IE7 or lower
            window.onload = func;
        } else {
            window.onload = func();
        }
    } else {
        window.onload = function() {
            if (oldonload) {
                oldonload();
            }
            func();
        }
    }
}
//addLoadEvent(function() {
$(document).ready(function() {
    $(function() { // ȸ��Ұ� ������
        if (!$('.compinfoArea').length) return false;
        moreButton($('.compinfoArea'));
    });
    $(function() { // ���� �� ���� ������
        if (!$('.comphistoryArea').length) return false;
        moreButton($('.comphistoryArea'));
    });
    $(function() { // ȸ�� �� ���λ���
        if (!$('.compictureArea').length) return false;
        hdpictureArea($('.compictureArea'));
    });
    $(function() { // �ֿ���ǰ����
        if (!$('.hdpictureArea').length) return false;
        $('.hdpictureArea').each(function(index, value) {
            hdpictureArea($(this));
        });
    });
    $(function() { // �ؽ�Ʈ ��ǲ ���
        if (!$('input.bg, textarea.bg').length) return false;
        inputBg($('input.bg, textarea.bg'));
    });
    $(function() { // ���� ����Ʈ
        if (!$('span.selectbox').length) return false;
        selectbox();
    });
    $(function() { // ���� �� ��ȿ���, ä��FAQ
        if (!$('.testsArea').length) return false;
        testsArea($('.testsArea'));
    });
    $(function() { // ��� �������� ä������
        if (!$('.detailHeader .button').length) return false;
        detailHeader($('.detailHeader'));
    });
    $(function() { // �Ի����� ���̾� �� X
        if (!$('#formFinish.layerWrap ul.panel').length) return false;
        layerWrapTab();
    });
    $(function() { // �Ի����� ���̾� �ݱ�
        if (!$('.layerWrap a.close').length) return false;
        layerWrapClose();
    });
    $(function() { // �����ϱ�
        if (!$('.tool .share ').length) return false;
        detailTopShare($('.tool .share'));
    });

    // ���̾� ��� ������¡
    $('div#applyWrap').bind('click', function() {
        fn_apply_layer_disp(null, false);
    });

    $("iframe#VList99").contents().find("body").focus();

});

/* �ε� �Լ� */
function detailTopShare(obj) { // �����ϱ�
    $(obj).bind('mouseenter focus', function() {
        $(this).parents('.tool').find('.btn').stop().show();
    }).bind('mouseleave blur', function() {
        $(this).parents('.tool').find('.btn').stop().delay(100).hide();
    });
    $($(obj.parents('.tool').find('.btn ul'))).bind('mouseenter focus', function() {
        $(this).parents('.tool').find('.btn').stop().show();
    }).bind('mouseleave blur', function() {
        $(this).parents('.tool').find('.btn').stop().delay(100).hide();
    });
}

function layerWrapClose() { // �Ի����� ���̾� �ݱ�
    var _layerWrapClose = $('.layerWrap a.close');
    _layerWrapClose.click(function() {
        $('.layerWrap').fadeOut(150);
        return false;
    });
}

function layerWrapTab() { // �Ի����� ���̾� �� hkkim@career.co.kr
    $('.layerWrap ul.panel > li:not(' + $('.layerWrap ul.tab > li.on a').attr('href') + ')').hide();
    var aa = $('.layerWrap ul.tab > li.on a img').attr('src').replace('off.gif', 'on.gif');
    $('.layerWrap ul.tab > li.on a img').attr('src', aa);

    $('.layerWrap ul.tab li a').click(function() {
        var _index = $('.layerWrap ul.tab li a').index(this);
        $('.layerWrap ul.tab li a').each(function(index, value) {
            if (_index == index) {
                $(this).parent().addClass('on');
                $(this).find('img').attr('src', $(this).find('img').attr('src').replace('off.gif', 'on.gif'));
            } else {
                $(this).parent().removeClass('on');
                $(this).find('img').attr('src', $(this).find('img').attr('src').replace('on.gif', 'off.gif'));
            }
        });
        $('.layerWrap ul.panel > li').hide();
        $($(this).attr('href')).show();
        return false;
    });
}

function detailHeader(obj) { // ��� �������� ä������
    var _detailHeader = obj;
    var _detailHeaderLst = _detailHeader.find('.lst');
    var _detailHeaderLi = _detailHeader.find('.lst > ul > li');
    var _detailHeaderPrev = _detailHeader.find('.page > a.prev');
    var _detailHeaderNext = _detailHeader.find('.page > a.next');
    var _detailHeaderNum = _detailHeader.find('.page > .num');
    var _detailHeaderBtn = _detailHeader.find('.button > a.btn');
    var _total = Math.ceil(_detailHeaderLi.length / 5);
    var _state = 1;

    if (Cookie.get('_detailHeaderCookie') == 'off') {
        _detailHeaderLst.addClass('off');
        _detailHeaderBtn.children('img').attr('src', _detailHeaderBtn.children('img').attr('src').replace('_on', '_off')).attr('alt', '����');
    } else {
        _detailHeaderLst.attr('class', 'lst');
    }

    _detailHeaderLi.each(function(index, value) { //���� �׸���ġ ����
        if ($(this).attr('class') == 'on')
            _state = Math.ceil((index + 1) / 5);
    });
    detailHeaderPageNum(_detailHeaderLi, _state);
    _detailHeaderNum.children('strong').text(_state);
    _detailHeaderNum.children('span').text(_total);

    _detailHeaderPrev.click(function() {
        if (_state > 1)
            _state--;
        else
            _state = 1;
        detailHeaderPageNum(_detailHeaderLi, _state);
        _detailHeaderNum.children('strong').text(_state);
        _detailHeaderNum.children('span').text(_total);
        return false;
    });
    _detailHeaderNext.click(function() {
        if (_state < _total)
            _state++;
        else
            _state = _total;
        detailHeaderPageNum(_detailHeaderLi, _state);
        _detailHeaderNum.children('strong').text(_state);
        _detailHeaderNum.children('span').text(_total);
        return false;
    });
    _detailHeaderLi.children('a').click(function() {
        _detailHeaderLi.removeClass('on');
        $(this).parent().addClass('on');
        location.href = this.href;
        return false;
    });
    _detailHeaderBtn.click(function() { // �ݱ� ��ư
        var _img = $(this).children('img');
        if (_detailHeaderLst.attr('class') == 'lst') {
            _detailHeaderLst.addClass('off');
            _img.attr('src', _img.attr('src').replace('_on', '_off')).attr('alt', '����');
            Cookie.set('_detailHeaderCookie', 'off');
        } else {
            _detailHeaderLst.removeClass('off');
            _img.attr('src', _img.attr('src').replace('_off', '_on')).attr('alt', '�ݱ�');
            Cookie.set('_detailHeaderCookie', 'on');
        }
        return false;
    });
}

function detailHeaderPageNum(obj, p) { // ��� �������� ä������ - ����¡
    $(obj).hide();
    var _total = p * 5
    var i = 0;
    if (p == 1)
        i = 0;
    else
        i = (p * 5) - 5;
    for (i; i < _total; i++) {
        if (obj.get(i) == undefined) return false;
        obj.get(i).style.display = 'block';
    }
}

function testsArea(obj) { // ���� �� ��ȿ���, ä��FAQ
    var _testsArea = obj;
    var _testsAreaQue = _testsArea.find('.que > a');
    _testsAreaQue.click(function() {
        var _ans = $(this).parent().next();
        if (_ans.css('display') == 'none') {
            $(this).parent().parent().parent().find('.ans').css('display', 'none');
            _ans.css('display', 'block');
        } else {
            _ans.css('display', 'none');
        }
        return false;
    });
}
inputFnc = function (obj) {//��ǲ�ڽ�
    var _this, _tmp, _bg = null;
    if (!obj)
        _this = $('input.txt, textarea.area');
    else
        _this = $(obj).find('input.txt, textarea.area');
    _this.unbind('focus blur').bind('focus', function () {
        _bg = ($(this).attr('class').indexOf('bg') > -1) ? true : false;
        $(this).addClass('on');//Ŭ���� ���
        if(_bg) $(this).removeClass('bg');
    }).bind('blur', function () {
        $(this).removeClass('on');//Ŭ���� ���
        if (_bg && $(this).val() == '') $(this).addClass('bg');
    });
}//��ǲ�ڽ�
$.fn.check = function(index) {//��ǲ�ؽ�Ʈ üũ
    return this.each(function(index, value) {
        var _default = $(this).attr('default');
        if(this.value == '' || this.value == _default) {
            $(this).attr('value', _default);
        } else {
            $(this).removeClass('value');
        }
        $(this).bind('focus', function() {
            if(this.value == _default) {
                this.value = '';
            }
            $(this).removeClass('value')
        }).bind('blur', function() {
            if(this.value == '' || this.value == _default) {
                this.value = _default;
                $(this).addClass('value');
            }
        });
    });
};//��ǲ�ؽ�Ʈ üũ


function inputBg(obj) { // �ؽ�Ʈ ��ǲ ���
    var _inputBg = obj;
    _inputBg.each(function(index, value) {
        if ($(this).val()) $(this).css('backgroundImage', 'none');
    });
    _inputBg.focus(function() {
        $(this).css('backgroundImage', 'none');
    }).blur(function() {
        if (!$(this).val()) $(this).removeAttr('style');
    });
}

function hdpictureArea(obj) { // ȸ�� �� ���λ���, �ֿ���ǰ����
    var _hdpictureArea = $(obj);
    var _hdpictureImg = _hdpictureArea.find('.image > img');
    var _hdpictureUl = _hdpictureArea.find('ul');
    var _hdpictureLi = _hdpictureArea.find('li');
    var _hdpictureA = _hdpictureArea.find('li > a');
    var _hdpictureUp = _hdpictureArea.find('.up');
    var _hdpictureDown = _hdpictureArea.find('.down');
    var _hdpictureTotal = _hdpictureLi.length % 4;
    var _hdpictureState = 0;
    if (_hdpictureArea.find('li').length > 4) {
        _hdpictureArea.find('.down > img').attr('src', _hdpictureArea.find('.down > img').attr('src').replace('_off', '_on'));
    }
    _hdpictureA.click(function() {
        var _index = _hdpictureUl.find('a').index(this);
        _hdpictureUl.find('a').each(function(index, value) {
            if (_index == index) $(this).parent().attr('class', 'on');
            else $(this).parent().removeAttr('class');
        });
        _hdpictureImg.attr('src', $(this).children('img').attr('src'));
        return false;
    });
    _hdpictureUp.click(function() {
        _hdpictureState--;
        if (_hdpictureState > 0) {
            $(this).children('img').attr('src', $(this).children('img').attr('src').replace('_off', '_on'));
            $(this).next().children('img').attr('src', $(this).next().children('img').attr('src').replace('_off', '_on'));
        } else {
            _hdpictureState = 0;
            $(this).children('img').attr('src', $(this).children('img').attr('src').replace('_on', '_off'));
        }
        _hdpictureUl.animate({
            top: -_hdpictureState * 352
        }, 150);
        return false;
    });
    _hdpictureDown.click(function() {
        _hdpictureState++;
        if (_hdpictureState < _hdpictureTotal - 1) {
            $(this).children('img').attr('src', $(this).children('img').attr('src').replace('_off', '_on'));
            $(this).prev().children('img').attr('src', $(this).prev().children('img').attr('src').replace('_off', '_on'));
        } else {
            (_hdpictureTotal == 0) ? _hdpictureState = 0: _hdpictureState = _hdpictureTotal - 1;
            $(this).children('img').attr('src', $(this).children('img').attr('src').replace('_on', '_off'));
        }
        _hdpictureUl.animate({
            top: -_hdpictureState * 352
        }, 150);
        return false;
    });
}

function moreButton(obj) { // ȸ��Ұ� ������
    var _moreButton = $(obj);
    var _moreButtonBtn = _moreButton.find('.more a.btn');
    _moreButtonBtn.unbind('click');
    _moreButtonBtn.click(function() {
        if ($(this).parent().prev().attr('class') == 'text') {
            $(this).children('img').attr({
                'src': $(this).children('img').attr('src').replace('_off', '_on'),
                'alt': '�ݱ�'
            });
            $(this).parent().prev().addClass('on');
        } else {
            $(this).children('img').attr({
                'src': $(this).children('img').attr('src').replace('_on', '_off'),
                'alt': '������'
            });
            $(this).parent().prev().removeClass('on');
        }
        return false;
    });
}
/* ����� ���� �Լ� */
/* ��Ű���� */
var Cookie = {
    cookie_arr: null,
    set: function(name, value, options) {
        options = options || {};
        this.cookie_arr = [escape(name) + '=' + escape(value)];
        //-- expires
        if (options.expires) {
            if (typeof options.expires === 'object' && options.expires instanceof Date) {
                var date = options.expires;
                var expires = "expires=" + date.toUTCString();
                this.cookie_arr.push(expires);
            }
        } else if (options.expires_day) {
            this.set_expires_date(options.expires_day, 24 * 60 * 60);
        } else if (options.expires_hour) {
            this.set_expires_date(options.expires_hour, 60 * 60);
        }

        //-- domain
        if (options.domain) {
            var domain = "domain=" + options.domain;
            this.cookie_arr.push(domain);
        }

        //-- path
        if (options.path) {
            var path = 'path=' + options.path;
            this.cookie_arr.push(path);
        }

        //-- secure
        if (options.secure === true) {
            var secure = 'secure';
            this.cookie_arr.push(secure);
        }

        document.cookie = this.cookie_arr.join('; ');
        //console.log (this.cookie_arr.join('; '));
    },

    get: function(name) {
        var nameEQ = escape(name) + "=";
        var ca = document.cookie.split(';');

        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length, c.length));
        }
        return null;
    },

    del: function(name, options) {
        options = options || {};
        options.expires_day = -1;
        this.set(name, '', options);
    },

    set_expires_date: function(expires, time) {
        var date = new Date();
        date.setTime(date.getTime() + (expires * time * 1000));
        var expires = "expires=" + date.toUTCString();
        this.cookie_arr.push(expires);
    }
};

function setComment(idx) { // ��۴� ���̾� - ���ú���
    var strComm;
    switch (idx) {
        case 1:
            strComm = '���� �Ļ��� ���� �ڼ��� �˰� �ͽ��ϴ�';
            break;
        case 2:
            strComm = '��� �Ϸ� �� ����� ��ȯ�� �����ϳ���?';
            break;
        case 3:
            strComm = '���� ��� �̿ܿ� Ÿ ��µ� ������ �ֽó���?';
            break;
        case 4:
            strComm = '������� ��� ���Ⱓ�� ��� �ǳ���?';
            break;
        case 5:
            strComm = '�������� ��, ������ ��� ���Ǵ� �������� �ֳ���?';
            break;
        case 6:
            strComm = '�����հ� �뺸�� �����ΰ���?';
            break;
        case 7:
            strComm = '�Բ� ���ϴ� ���� �� �� �μ��ΰ���(�Ǵ� ���) ������ �˰� �ͽ��ϴ�.';
            break;
        case 8:
            strComm = '������ ���� �߿�� ���� �׸�� ���� ���Ѿ� �� �׸��� �����ΰ���?';
            break;
        case 9:
            strComm = '�ڰݿ�� ��³���� ���� �̴��ϴµ� ������ �����ұ��?';
            break;
        case 10:
            strComm = '���� ������ ���� �ǰ���?';
            break;
    }
    var IE = (document.all) ? true : false;
    if (IE) {
        window.clipboardData.setData('Text', strComm);
        alert('����Ǿ����ϴ�. ��۴㿡 �ٿ��ֱ�(Ctrl+v)�� �ٿ� ��������.');
    } else {
        prompt('����(ctrl+c) �Ͻ���, ��۴㿡 �ٿ��ֱ�(Ctrl+v)�� �ٿ� ��������.', strComm);
    }
}

function informPop() { // ��۴� ���̾� - Ȱ���ϱ�
    document.getElementById("rulePopup").style.display = "";
    document.getElementById("tabCls").className = "tabmenu tab1";
}

function rulePop() { // ��۴� ���̾� - ���Ģ
    document.getElementById("rulePopup").style.display = "";
    document.getElementById("tabCls").className = "tabmenu tab2";
}

function layerWrapView(obj, param, closer) { // �Ի����� ���̾� ���̱�
    var _layerWrapView = $('.layerWrap.' + param);
    var _layerWrapPopup = _layerWrapView.children('.layerPopup');
    _layerWrapView.css('height', $(document).height()).fadeOut(150);
    $("html, body").animate({
        scrollTop: $(obj).offset().top
    }, 300);
    _layerWrapPopup.css('top', $(obj).offset().top + 'px');
    _layerWrapView.fadeIn(150);
    $(closer).parents('.layerWrap').css('display', 'none');
}


function windowPopup(url, name, w, h) { // ������ �˾�
    window.open(url, name, 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=' + w + ',height=' + parseInt(h + 10) + ',top=0,left=0');
}

disableFnc = function (obj, param, objthis) {//��Ȱ��

    var _obj = $(obj);
    var _input = _obj.find('input.txt, input.rdi, input.chk, textarea.area');
    var _this = $(objthis);
    var _thisId = $(objthis).attr('id')

    switch(param) {
        case 'disable':
            _obj.addClass('disable');
            if (_input.length > 0) _input.attr('readonly','readonly');
            selectboxFnc();
            break;
        case 'active':
            _obj.removeClass('disable');
            if (_input.length > 0) _input.removeAttr('readonly');
            break;
        case 'hidden':
            if($("input:checkbox[id='"+_thisId+"']").is(":checked") == true) {
                _this.parent().prev().removeClass('disable').find('input.txt').attr("disabled", false);
            } else {
                _this.parent().prev().addClass('disable').find('input.txt').attr("disabled", true);
            }
            break;
        case 'check'://üũ�ڽ�
            if ((_obj.attr('class')) ? (_obj.attr('class') == 'disable') : false) {
                _obj.removeClass('disable');
                if (_input.length > 0) _input.removeAttr('readonly');
            } else {
                _obj.addClass('disable');
                if (_input.length > 0) _input.attr('readonly','readonly');
            }
            break;
        default:
            return false;
    }
};//��Ȱ��

function selectbox() { //���� ����Ʈ
    $('.selectbox select').each(function(index, value) {
        $(this).prev().html($(this).children('option:selected').text());
    }).bind('click', function() {
        $(this).prev().html($(this).children('option:selected').text());
    });
}


selectboxFnc = function (obj) {//����Ʈ�ڽ�
    var _select = null
    if (!obj)
        _select = $('.selectbox select');
    else
        _select = ($(obj).find('.selectbox select').length > 0) ? $(obj).find('.selectbox select') : $(obj);
    _select.unbind().each(function (index, value) {
        $(this).prev().html($(this).children('option:selected').text());
        if ($(this).val() == 'direct') {//�����Է�
            $(this).parent().prev().css('display', 'inline');
        }
    }).bind('change keyup', function (evt) {
        $(this).prev().html($(this).children('option:selected').text());
        if ($(this).prev().is('.ellipsis')) $(this).prev().ellipsis();//������ ����
        if ($(this).find("option[value='direct']").length == 1) {//�����Է� ����
            if ($(this).val() == 'direct') {
                $(this).parent().prev().css('display', 'inline');
                if (evt.type == 'change') $(this).parent().prev().focus();//�����Է� ��Ŀ�� �̵�
            } else {
                $(this).parent().prev().css('display', 'none');
            }
        }
    }).bind('focus', function () {
        $(this).prev().addClass('on');
    }).bind('blur', function () {
        $(this).prev().removeClass('on');
    });
}//����Ʈ�ڽ�

selectboxFncTT = function (obj) {//����Ʈ�ڽ�
    alert("ttt");
    var _select = null
    if (!obj)
        _select = $('.selectbox select');
    else
        _select = ($(obj).find('.selectbox select').length > 0) ? $(obj).find('.selectbox select') : $(obj);
    _select.unbind().each(function (index, value) {
        $(this).prev().html($(this).children('option:selected').text());
        if ($(this).val() == 'direct') {//�����Է�
            $(this).parent().prev().css('display', 'inline');
        }
    }).bind('change keyup', function (evt) {
        $(this).prev().html($(this).children('option:selected').text());
        if ($(this).prev().is('.ellipsis')) $(this).prev().ellipsis();//������ ����
        if ($(this).find("option[value='direct']").length == 1) {//�����Է� ����
            if ($(this).val() == 'direct') {
                $(this).parent().prev().css('display', 'inline');
                if (evt.type == 'change') $(this).parent().prev().focus();//�����Է� ��Ŀ�� �̵�
            } else {
                $(this).parent().prev().css('display', 'none');
            }
        }
    }).bind('focus', function () {
        $(this).prev().addClass('on');
    }).bind('blur', function () {
        $(this).prev().removeClass('on');
    });
}//����Ʈ�ڽ�

function viewPopup(obj) { // �˾�����
    window.open(obj, 'popupView' + new Date().getTime(), 'top=0,left=' + window.screen.availWidth / 5 + ',toolbar=no,location=yes,directories=no,status=no,scrollbars=yes,menubar=no,width=739,height=' + window.screen.availHeight);
}

function resizeBackground(h) { //���̾� ��� �������� skydown@career.co.kr
    if (h > 0 && $('div#applyWrap').height() < $(document).height()) $('div#applyWrap').height($(document).height() + 50);
}

function resizeIFrame(ifr_id, re) {
    try {
        //���α��̴� �������� ��찡 �幰�� ������ �ּ�ó��!
        var ifr = document.getElementById(ifr_id);
        var innerBody = ifr.contentWindow.document.body;
        var innerHeight = innerBody.scrollHeight; // + (innerBody.offsetHeight - innerBody.clientHeight);
        var numIfrHeight = ifr.style.height.replace("px", "");
        if (numIfrHeight == "") numIfrHeight = "0";
        if (parseInt(numIfrHeight) != parseInt(innerHeight)) //�ּ����Ž� ���� �������� ��ü -> if (ifr.style.height != innerHeight || ifr.style.width != innerWidth)
        {
            ifr.style.height = innerHeight + 'px';
            resizeBackground(innerHeight);
            if (ifr_id == 'applyFrame') fn_apply_layer_top();
        }
    } catch (e) {}
}

// ifrm_apply2014.asp ȣǮ�ϴ� ��ũ��Ʈ
function resizeIFrame2(ifr_id, re) {
    try {
        //���α��̴� �������� ��찡 �幰�� ������ �ּ�ó��!
        var ifr = document.getElementById(ifr_id);
        var innerBody = ifr.contentWindow.document.body;
        var innerHeight = innerBody.scrollHeight; // + (innerBody.offsetHeight - innerBody.clientHeight);
        if (parseInt(ifr.style.height) != innerHeight) //�ּ����Ž� ���� �������� ��ü -> if (ifr.style.height != innerHeight || ifr.style.width != innerWidth)
        {
            ifr.style.height = innerHeight + 'px';
            resizeBackground(innerHeight);
            if (ifr_id == 'applyFrame') fn_apply_layer_top();
        }
    } catch (e) {}
}


function resizeIFrame11(ifr_id, re, _numGap) {
    if (_numGap == "") {
        _numGap = 0;
    }

    //���α��̴� �������� ��찡 �幰�� ������ �ּ�ó��!
    if (!parent.document.getElementById(ifr_id)) return false;
    var ifr = parent.document.getElementById(ifr_id);
    var innerBody = ifr.contentWindow.document.body;
    var innerHeight = innerBody.scrollHeight + (innerBody.offsetHeight - innerBody.clientHeight);

    var numIfrHeight = ifr.style.height.replace("px", "");
    if (numIfrHeight == "") numIfrHeight = "0";

    innerHeight = innerHeight + _numGap
    if (parseInt(ifr.style.height) != innerHeight) //�ּ����Ž� ���� �������� ��ü -> if (ifr.style.height != innerHeight || ifr.style.width != innerWidth)
    {
        ifr.style.height = innerHeight + 'px';
        resizeBackground(innerHeight);
        if (ifr_id == 'applyFrame') fn_apply_layer_top();
    }

}

function fnCloseLayerLogin() {
    $('div#applyWrap').css('display', 'none');
    $('iframe#applyFrame').attr('src', 'about:blank');
}


function customer_pop(id_num) {
    window.open('/help/pop_customer.asp?id_num=' + id_num, '', 'width=570, height=345');//width=570, height=345
}

function tooltipFnc() {//Q&A
    $(".requestAnswer a").mouseenter(function(){
        $('.requestAnswer .box').show();
    });
    $(".requestAnswer a").mouseleave(function(){
        $('.requestAnswer .box').hide();
    });

    $(".requestAnswer .box button").click(function(){
        $(this).parent().hide();
    });
}//Q&A

qnaNotiFnc = function (obj, obj1, obj2) {//Q&A�˸�
    var _this = $(obj);
    var _close = $("#receiveNoti button")
    var _areaN = $(obj1)
    var _area = $(obj2)

    _areaN.css("display","block");
    _area.css("display","none");
        _close.click(function(){
        $(this).parent().hide();
    });
}//Q&A�˸�



// Javascript End
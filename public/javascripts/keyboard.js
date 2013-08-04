// QWERTY Keyboard
var row = Array();
row[0] = '`1234567890-=';
row[1] = 'qwertyuiop[]\\';
row[2] = 'asdfghjkl;\'';
row[3] = 'zxcvbnm,./';

var shift = Array();
shift[0] = '~!@#$%^&*()_+';
shift[1] = 'QWERTYUIOP{}|';
shift[2] = 'ASDFGHJKL:"';
shift[3] = 'ZXCVBNM<>?';

var ignorekey = 0;

var keyboard;
var target;
//var callback; /* Deprecated? */

function Keyboard() {
	this.keylist = Array();
	this.shiftmap = Array();
	this.keyboard = this.createKeyboardDocumentTree();
}

Keyboard.prototype.getElement = function () {
  return this.keyboard
}

Keyboard.prototype.setTargetElement = function (el) {
	//debug("New target: " + el);
	this.target = el;
}

Keyboard.prototype.attachToAllInputs = function () {
	var nodes = document.getElementsByTagName("input");
	var set = 0;
	for (var i = 0; i < nodes.length; i++) {
		if (nodes[i].type == "password" || nodes[i].type == "text") {
			if (typeof(addEvent) == "function") addEvent(nodes[i], "focus", this.newfocus);
			else nodes[i].onfocus = this.newfocus;

			nodes[i].keyboardIndex = i;
			nodes[i].keyboardObject = this;
		}
	}
}

/* XXX: This function is not called in object-oriented fashion? */
Keyboard.prototype.newfocus = function() {
	this.keyboardObject.setTargetElement(this);
}

Keyboard.prototype.createKeyboardDocumentTree = function() {
	var bigpicture = document.createElement("div");;
	var kbd = document.createElement("div");

	//bigpicture.onselectstart = new Function('return false');
	bigpicture.style.border="10px solid black";
	bigpicture.style.width="100%";
	//bigpicture.style.left="100px";
	
	
	for (var i = 0; i < row.length; i++) {
		var keyrow = document.createElement("div");
		keyrow.style.padding="13px";
		keyrow.style.marginLeft="80px";
		
		
		if (i == 1) { /* Add the tab key */
			var tab = this.createkey("Tab");
			//tab.paddingRight="25px";
			keyrow.appendChild(tab);
		} else if (i == 2) {
			var caps = this.createkey("Caps");
			caps.style.paddingRight="25px";
			keyrow.appendChild(caps);
		} else if (i == 3) {
			var shiftkey = this.createkey("Shift");
			shiftkey.style.paddingRight="45px";
			keyrow.appendChild(shiftkey);
		}
		for (var x = 0; x < row[i].length; x++) {
			keyrow.appendChild(this.createkey(row[i].substring(x,x+1), shift[i].substring(x,x+1)));
		}

		if (i == 0) {
			var backspace = this.createkey("Del");
			backspace.style.paddingLeft="17px";
			keyrow.appendChild(backspace);
		} else if (i == 2) {
			var enter = this.createkey("Enter");
			keyrow.appendChild(enter);
		} else if (i == 3) {
			var shiftkey = this.createkey("Shift");
			shiftkey.style.paddingLeft="33px";
			keyrow.appendChild(shiftkey);
		}
		kbd.appendChild(keyrow);
	}
	var keyrow = document.createElement("div");
	keyrow.style.padding="13px";
	var space = this.createkey("Space");
	space.style.paddingLeft = "120px";
	space.style.paddingRight = "120px";
	space.style.marginTop = "-20px";
	space.style.marginLeft = "250px";
	keyrow.appendChild(space);
	kbd.appendChild(keyrow);

	bigpicture.appendChild(kbd);

	return bigpicture;
}

Keyboard.prototype.createkey = function(label, extra) {
	var key = document.createElement("div");
	key.className="key";
	key.id="key";
	key.keyboardObject = this;
	if (typeof(addEvent) == "function") addEvent(key, "mousedown", this.keydown);
	else key.onmousedown = this.keydown;
	if (typeof(addEvent) == "function") addEvent(key, "mouseup", this.keyup);
	else key.onmouseup = this.keyup;

	var keytext = document.createTextNode(label);
	key.appendChild(keytext);

	if (extra) {
		this.shiftmap[label] = extra;
		this.shiftmap[extra] = label;
	}
	this.keylist.push(key);
	return key;
}

Keyboard.prototype.keydown = function (me) {
	if (!me.childNodes)
		me = this;
	var str = me.childNodes[0].nodeValue;
	var kbd = me.keyboardObject;
	var target = kbd.target

	if (ignorekey && me == lastkey) {
		return false;
	}

	if (target) {
		if (str.length == 1) {
			target.value+=str;
			if (kbd.shiftup) {
				kbd.shiftchars();
				kbd.shiftup = 0;
			}
		} else if (str == "Space") {
			target.value+=" ";
		} else if (str == "Del") {
			target.value = target.value.substr(0,target.value.length - 1);
		} else if (str == "Caps") {
			kbd.shiftchars();
		} else if (str == "Shift") {
			kbd.shiftup = (kbd.shiftup) ? 0 : 1;
			kbd.shiftchars();
		}
	} else {
		debug("No target set for keyboard.");
		return false;
	}

	if (!kbd.lastkey || kbd.lastkey != me) {
		if (str == "Del") {
			/* Do key repeating */
			kbd.lastkey = me;
			//if (kbd.repeater)
				//clearTimeout(kbd.repeater)
			kbd.repeater = setTimeout(function() { kbd.repeatkey() }, 500);
		}
	}

	return false;
}

Keyboard.prototype.debug = function(text) {
	var div = document.createElement("div");
	div.appendChild(document.createTextNode(text));
	document.body.appendChild(div);
}

Keyboard.prototype.keyup = function() {
	this.keyboardObject.lastkey = null;
	if (this.keyboardObject.repeater)
		clearTimeout(this.keyboardObject.repeater)
}

Keyboard.prototype.repeatkey = function() {
	if (this.lastkey) {
		this.keydown(this.lastkey);
		var t = this;
		setTimeout(function() { t.repeatkey() }, 1000/20);
	}
}

Keyboard.prototype.shiftchars = function() {
	for (var i = 0; i < this.keylist.length; i++) {
		var nodeval = this.keylist[i].childNodes[0].nodeValue;
		if (nodeval.length == 1) {
			this.keylist[i].childNodes[0].nodeValue = this.shiftmap[nodeval];
		}
	}
}

debug = Keyboard.prototype.debug;

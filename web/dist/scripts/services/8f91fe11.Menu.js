'use strict';

webApp.factory('Menu', function() {
	var MenuResource = function(obj) {
		this._name = obj.name;
		this.name = obj.name;
		this.subtitle = obj.subtitle;
		this.url = obj.url;
		this.icon = obj.icon;
		this._description = obj.description;
		this.description = obj.description;
		this.menuOrder = obj.menuOrder;
		this.children = [];
		this.parent = undefined;
		this.hash = obj.hash || function() { return "#"; };
		this.target = function() { return (this.hash() != "#" ? "_blank" : "_self") ; };
		this.show = obj.show == undefined ? true : obj.show;
		return this;
	};

	MenuResource.prototype.addChild = function(child) {
		var c = child;
		c.parent = this;
		this.children.push(c);
		return c;
	};

	MenuResource.prototype.addChildren = function(children) {
		for (var child in children) {
			this.addChild(children[child]);
		}
		return this;
	};

	MenuResource.prototype.isLeaf = function() {
		return (this.children == {} || this.children.length == 0);
	};

	MenuResource.prototype.hasChildren = function() {
		return !this.isLeaf();
	};

	MenuResource.prototype.hasBrothers = function() {
		return (this.parent != null && this.parent.children != null && this.parent.children != {});
	};

	MenuResource.prototype.hasUrl = function(url) {
		var hasIt = false;
		angular.forEach(this.url(), function(cUrl) {
			if (cUrl == url) {
				hasIt = true;
				return;
			}
		});
		return hasIt;
	}

	MenuResource.prototype.mainUrl = function() {
		return this.url()[0];
	}

	MenuResource.prototype.isActive = function(url, strict, ret) {
		var hasIt = false;
		ret = ret || {t: true, f: false};
		strict = strict || ret.f || false;

		// Check for every URL in the function
		angular.forEach(this.url(), function(cUrl) {
			if (cUrl == url) {
				hasIt = ret.t || true;
				return;
			}
		});
		// If the URL is not active and the checking
		// is not strict, check for its children
		if (!hasIt && !strict) {
			angular.forEach(this.children, function(cChild) {
				if (cChild.isActive(url, strict, ret)) {
					hasIt = ret.t || true;
					return;
				}
			});
		}
		return hasIt;
	}

	MenuResource.prototype.isDropdown = function(ret) {
		ret = ret || {t: true, f: false};
		if (this.hasChildren()) return ret.t || true;
	}

	return MenuResource;
});

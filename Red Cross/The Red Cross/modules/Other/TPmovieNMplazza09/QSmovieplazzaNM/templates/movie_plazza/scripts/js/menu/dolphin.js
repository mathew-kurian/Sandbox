var dolphintabs={
	subcontainers:[], last_accessed_tab:null,
	revealsubmenu:function(curtabref){
	this.hideallsubs()
	if (this.last_accessed_tab!=null)
		this.last_accessed_tab.className=""
		if (curtabref.getAttribute("rel")) //If there's a sub menu defined for this tab item, show it
		document.getElementById(curtabref.getAttribute("rel")).style.display="block"
		//document.getElementById(curtabref.getAttribute("rel")).style.height="20px"
		//document.getElementById(curtabref.getAttribute("rel")).style.padding="5px"
		curtabref.className="current"
		this.last_accessed_tab=curtabref
	},
	hideallsubs:function(){
	for (var i=0; i<this.subcontainers.length; i++)
		document.getElementById(this.subcontainers[i]).style.display="none"
	},
	init:function(menuId, selectedIndex){
	var tabItems=document.getElementById(menuId).getElementsByTagName("a")
		for (var i=0; i<tabItems.length; i++){
			if (tabItems[i].getAttribute("rel"))
				this.subcontainers[this.subcontainers.length]=tabItems[i].getAttribute("rel")
				if(selectedIndex != 0) {
					if (i==selectedIndex){ //if this tab item should be selected by default
					tabItems[i].className="current"
					this.revealsubmenu(tabItems[i])
				}
			}
			tabItems[i].onmouseover=function(){
			dolphintabs.revealsubmenu(this)
			}
		}
	}
}
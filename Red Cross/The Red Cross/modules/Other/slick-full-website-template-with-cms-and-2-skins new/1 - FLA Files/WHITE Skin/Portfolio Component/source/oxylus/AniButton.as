import oxylus.Utils;

class oxylus.AniButton extends MovieClip {	
	public function AniButton() {
		this.stop();
	}
	
	private function onRollOver() {
		Utils.mcPlay(this, 0);
		this["$onRollOver"].call(this);
	}
	private function onRollOut() {
		Utils.mcPlay(this, 1);
		this["$onRollOut"].call(this);
	}
	private function onReleaseOutside() {
		Utils.mcPlay(this, 1);
		this["$onReleaseOutside"].call(this);
	}
}

/**
 * XNetStream
 * NetStream extended
 *
 * @version		1.0
 */
package _project.classes {
	import flash.net.NetConnection;
	import flash.net.NetStream;
	//
	public dynamic class XNetStream extends NetStream {
		//private vars...
		private var __netconnection:NetConnection;
		//
		//constructor...
		public function XNetStream(netConnection:NetConnection) {
			super(netConnection);
		};
	};
};

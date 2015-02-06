package colorwheelPreloader_fla
{
    import flash.display.*;
    import flash.events.*;

    dynamic public class MainTimeline extends MovieClip
    {
        public var status_mc:MovieClip;
        public var procentLoaded:Number;
        public var FAKE_MODE:Boolean;

        public function MainTimeline()
        {
            addFrameScript(0, frame1, 40, frame41);
            return;
        }// end function

        public function onPreload(param1:ProgressEvent) : void
        {
            this.procentLoaded = this.loaderInfo.bytesLoaded / this.loaderInfo.bytesTotal * 100;
            this.setText();
            this.checkReady();
            return;
        }// end function

        function frame1()
        {
            FAKE_MODE = true;
            procentLoaded = 0;
            if (FAKE_MODE)
            {
                this.addEventListener(Event.ENTER_FRAME, onFakemode);
            }
            else
            {
                this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onPreload);
            }// end else if
            trace("Compressed movie size: " + this.loaderInfo.bytesTotal + " bytes");
            stop();
            return;
        }// end function

        public function onFakemode(param1:Event) : void
        {
            this.procentLoaded = this.procentLoaded + 0.4;
            this.setText();
            this.checkReady();
            return;
        }// end function

        public function checkReady() : void
        {
            if (this.procentLoaded > 99)
            {
                trace("Movie preloaded");
                this.stopPreloading();
            }// end if
            return;
        }// end function

        public function setText() : void
        {
            var _loc_1:Number;
            _loc_1 = this.procentLoaded >> 0;
            this.status_mc.status_txt.text = _loc_1 < 10 ? ("0" + _loc_1.toString()) : (_loc_1.toString());
            return;
        }// end function

        function frame41()
        {
            stop();
            return;
        }// end function

        public function stopPreloading() : void
        {
            this.status_mc.status_txt.text = "100";
            if (FAKE_MODE)
            {
                this.removeEventListener(Event.ENTER_FRAME, onFakemode);
            }
            else
            {
                this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onPreload);
            }// end else if
            this.gotoAndPlay("preloadReady");
            return;
        }// end function

    }
}

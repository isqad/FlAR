package 
{
    import PV3DARApp.*;
    import flash.events.*;
    import org.papervision3d.events.*;
    import org.papervision3d.objects.parsers.*;

    public class Earth extends PV3DARApp
    {
        private var model:Max3DS;

        public function Earth()
        {
            addEventListener(Event.INIT, _onInit);
            init("Data/camera_para.dat", "Data/marker10.pat");
            return;
        }// end function

        private function _onInit(event:Event) : void
        {
            model = new Max3DS();
            Max3DS(model).load("model/roll10.3DS", null, "model/");
            model.addEventListener(FileLoadEvent.LOAD_COMPLETE, onModelLoaded);
            return;
        }// end function

        private function _update(event:Event) : void
        {
            model.yaw(1.0);
            return;
        }// end function

        private function onModelLoaded(event:FileLoadEvent) : void
        {
            model.scale = 2.2;
            model.z = 250;
            model.y = -9;
            model.rotationZ = 90;
            model.rotationX = 90;
            model.rotationY = 120;
            model.screenZ = 30;
            _markerNode.addChild(model);
            addEventListener(Event.ENTER_FRAME, _update);
            return;
        }// end function

    }
}

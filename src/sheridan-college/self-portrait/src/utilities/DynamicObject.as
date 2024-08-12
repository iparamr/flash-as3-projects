package src.utilities 
{
    import flash.utils.*;
    
    public class DynamicObject extends Object
    {
        public function DynamicObject()
        {
            super();
            return;
        }

        public static function copy(arg1:Object):*
        {
            var loc1:*=null;
            loc1 = new flash.utils.ByteArray();
            loc1.writeObject(arg1);
            loc1.position = 0;
            return loc1.readObject();
        }
    }
}

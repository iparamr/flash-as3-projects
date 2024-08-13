package src.utilities 
{
    import flash.utils.ByteArray;
    
    public class DynamicObject 
    {
        public function DynamicObject()
        {
            super();
        }

        public static function copy(source:Object):*
        {
            var byteArray:ByteArray = new ByteArray();
            byteArray.writeObject(source);
            byteArray.position = 0;
            return byteArray.readObject();
        }
    }
}

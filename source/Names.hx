package ;
class Names {

    public static var names:Array<String> = ["Jim", "Cody", "Lacey", "Bob", "Sam", "Josh", "Hayato", "Devin", "Ashley", "Sai", "Kevin", "Frank", "Tiff"];

    public static function getName():String {
        return names[Math.floor(Math.random()* names.length)];
    }
}

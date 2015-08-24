package ;
class Names {

    public static var names:Array<String> = ["Jim", "Cody", "Lacey", "Bob", "Sam", "Josh", "Hayato", "Devin", "Ashley", "Sai", "Kevin", "Frank", "Tiff", "Max", "Erin",
        "Michelle", "Nick", "John", "Sarah", "Alex", "Kate", "Nicole", "Daniel", "Rob", "Kyle", "Anna", "Tyler", "Derek", "Zoey", "Ellen", "Michael", "Trevor", "Danielle"];

    public static function getName():String {
        return names[Math.floor(Math.random()* names.length)];
    }
}

import Kitura
import HeliumLogger
import LoggerAPI
import KituraStencil

let router = Router()

router.setDefault(templateEngine: StencilTemplateEngine())

router.all("/static", middleware: StaticFileServer())

HeliumLogger.use()


router.get("/") {
    request, response, next in
    defer {next()}
    try response.render("home", context: [:])
}

router.get("/contact") {
    request, response, next in
    defer {next()}
    try response.render("contact", context: [:])
}
let bios = [
    "kirk":"My name is James Kirk and I love snakes",
    "picard":"My name is Jean-Luc Picard and I'm mad for cats",
    "sisko":"My name is Benjamin Sisko and I'm all about the budgies",
    "janeway":"My name is Kathryn Janeway and I want to hug every hamster",
    "archer":"My name is Jonathan Archer and beagles are my thing"
]

router.get("/staff") {
    request, response, next in
    defer {next()}
    var context = [String:Any]()
    context["people"] = Array(bios.keys)
    try response.render("staffpage", context: context)
}

router.get("/staff/:name") {
    request, response, next in
    defer {next()}
    guard let name = request.parameters["name"] else { return }
    
    
    var context = [String:Any]()
    if let bio = bios[name] {
        context["name"] = name
        context["bio"] = bio
        context["people"] = Array(bios.keys)
    }
    try response.render("staff", context: context)
}

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()


const express = require("express");
const app = express();
const seed = require("./seedDB");
const methodOverride = require("method-override");
const bodyParser = require("body-parser");
const session = require("express-session");
const passport = require("passport");
const initializePassport = require("./passportConfig");
initializePassport(passport);
app.use(express.json());
app.use(bodyParser.urlencoded({extended:true}));
app.use(
	session ({
		secret: "This backend was created by Tarun",
		resave : false,
		saveUninitialized: false
	})
);
app.use(passport.initialize());
app.use(passport.session());
app.set("view engine","ejs");
app.use(methodOverride('_method'));

// Seeding
seed();
// Routes
const movieRouters = require("./routes/movies");
const loginRouters = require("./routes/login");
const distriRouters = require("./routes/distributor");
const empRouters = require("./routes/employees");
const rentRouters = require("./routes/rents");
const payRouters = require("./routes/payments");
const customRouters = require("./routes/customers");
const storeRouters = require("./routes/stores");
app.use(movieRouters);
app.use(loginRouters);
app.use(distriRouters); 
app.use(empRouters);  
app.use(rentRouters);
app.use(payRouters);
app.use(customRouters);
app.use(storeRouters);
// Server config
app.listen(process.env.PORT || 7777, process.env.IP,()=>{
	console.log("DBMS Miniproject server started");
})	
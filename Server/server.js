const express = require('express');
const cors = require('cors');
const con = require('./src/config/Database');
const cookieParser = require('cookie-parser');
const authRouter = require('./src/routes/authRoutes');
const carsBangkhen = require('./src/routes/carRoutes/carBangKhen');
const carsMonument = require('./src/routes/carRoutes/carMonument');
const carsSaiTai = require('./src/routes/carRoutes/carSai_Tai');
const carBooking = require('./src/routes/booking/carBooking');
const app = express();
app.use(cors());
app.use(cookieParser());
app.use(express.json());
app.use(express.static('public'));

let PORT = process.env.PORT || 8081;


con.connect(function(err){
    if(err) {
        console.log("Error in Connection");
    }else {
        console.log("Connected");
    }
})

app.use('/auth', authRouter);
app.use('/carBangkhen', carsBangkhen);
app.use('/carMonument', carsMonument);
app.use('/carSaiTai', carsSaiTai);
app.use('/booking', carBooking);

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}.`);
  });



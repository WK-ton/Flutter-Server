const express = require('express');
const BookingCars = require('../../controllers/Users/users_booking');
const router = express.Router();
const upload = require('../../middleware/multer');


router.post('/create/cars', upload.single('image'), BookingCars.booking_cars);
router.get('/get/user', BookingCars.booking_users);
router.get('/get/booking', BookingCars.showBooking);
router.post('/create/qrcode', BookingCars.qrCode);
// router.post('/api/seats', BookingCars.reserve);
router.get('/api/getSeats', BookingCars.getseats);
router.put('/update/booking/:id', BookingCars.updateStatus);
router.delete('/delete/booking/:id', BookingCars.deleteBooking);
module.exports = router;
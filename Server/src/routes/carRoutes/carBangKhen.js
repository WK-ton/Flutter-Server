const express = require('express');
const CarsBangkhen = require('../../controllers/Admin/CarControllers/carsBangKhen');
const router = express.Router();
const upload = require('../../middleware/multer');

router.post('/create/cars_bangkhen', upload.single('image'), CarsBangkhen.create_carsBangKhen);
router.get('/getCars/cars_bangkhen', CarsBangkhen.getCars_carsBangKhen);
router.get('/get/cars_bangkhen/:id', CarsBangkhen.getCarById_carsBangKhen);
// router.get('/number', CarController.getAllNumber);
router.put('/update/cars_bangkhen/:id', CarsBangkhen.updateCar_carsBangKhen);
router.delete('/delete/cars_bangkhen/:id', CarsBangkhen.deleteCar_carsBangKhen);
// router.get('/image', CarController.getCarImage);
// router.get('/', CarController.getNumber)
module.exports = router;
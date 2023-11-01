const express = require('express');
// const CarController = require ('../controllers/Admin/carController');
const CarsMonument = require('../../controllers/Admin/CarControllers/carsMonument');
const router = express.Router();
const upload = require('../../middleware/multer');

router.post('/create/cars_monument', upload.single('image'), CarsMonument.create_carsMonument);
router.get('/getCars/cars_monument', CarsMonument.getCars_carsMonument);
router.get('/get/cars_monument/:id', CarsMonument.getCarById_carsMonument);
// router.get('/number', CarController.getAllNumber);
router.put('/update/cars_monument/:id', CarsMonument.updateCar_carsMonument);
router.delete('/delete/cars_monument/:id', CarsMonument.deleteCar_carsMonument);
// router.get('/image', CarController.getCarImage);
// router.get('/', CarController.getNumber)
module.exports = router;
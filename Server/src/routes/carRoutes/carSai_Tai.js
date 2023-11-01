const express = require('express');
// const CarController = require ('../controllers/Admin/carController');
const Cars_Sai_Tai = require('../../controllers/Admin/CarControllers/carsSai_Tai');
const router = express.Router();
const upload = require('../../middleware/multer');

router.post('/create/cars_SatTai', upload.single('image'), Cars_Sai_Tai.create_carsSai_Tai);
router.get('/getCars/cars_SatTai', Cars_Sai_Tai.getCars_carsSai_Tai);
router.get('/get/cars_SatTai/:id', Cars_Sai_Tai.getCarById_carsSai_Tai);
// router.get('/number', CarController.getAllNumber);
router.put('/update/cars_SatTai/:id', Cars_Sai_Tai.updateCar_carsSai_Tai);
router.delete('/delete/cars_SatTai/:id', Cars_Sai_Tai.deleteCar_carsSai_Tai);
// router.get('/image', CarController.getCarImage);
// router.get('/', CarController.getNumber)
module.exports = router;
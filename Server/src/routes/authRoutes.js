const express = require('express');
const authController = require('../controllers/Admin/authController');
const UserController = require('../controllers/Users/users_auth');
// const userMiddleware = require('../middleware/authentication');
const router = express.Router();
const upload = require('../../src/middleware/multer');


router.post('/sign-up', UserController.signUp);
router.post('/Adminlogin', authController.login);
router.post('/userLogin', UserController.userLogin);
router.get('/getUser', UserController.getUsers);
router.get('/getName/:id', UserController.getName);
router.delete('/delete/user/:id', UserController.deleteUser);
router.put('/update/username/:id', upload.single('image'), UserController.updateUserName);
router.put('/update/userimage/:id',upload.single('image'), UserController.updateUserImage);
router.get('/', UserController.getItem);
router.post('/insert/image', upload.single('image'), UserController.insertImage);
module.exports = router;
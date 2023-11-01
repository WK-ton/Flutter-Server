const con = require("../../config/Database");
const QRCode = require("qrcode");
const generatePayload = require("promptpay-qr");
const _ = require("lodash");
const moment = require('moment-timezone');

exports.booking_cars = (req, res) => {
  const checksql =
  `SELECT * FROM booking WHERE fromstation = ? AND tostation = ? AND date = ? AND time = ? AND seat = ?`;
  const check = [
    req.body.fromstation,
    req.body.tostation,
    req.body.date,
    req.body.time,
    req.body.seat
  ];
  con.query(checksql, check, (err, result) => {
    if (err) {
      console.error("เกิดข้อผิดพลาดในการตรวจสอบที่นั่ง:", err);
      return res.status(500).json({ error: "เกิดข้อผิดพลาดในการตรวจสอบที่นั่ง" });
    } else if (result.length > 0) {
      res.status(400).json({error: 'ที่นั่งถูกจองแล้ว'})
    } else {
    const sql =
      "INSERT INTO booking (`fromstation`, `tostation`, `number`, `name`, `email`, `phone`, `date`, `time`, `road`, `amount`, `image`, `time_image`, `date_image`, `row`, `col`, `seat`, `accept`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)";
    const values = [
      req.body.fromstation,
      req.body.tostation,
      req.body.number,
      req.body.name,
      req.body.email,
      req.body.phone,
      req.body.date,
      req.body.time,
      req.body.road = req.body.road.substring(0, 255),
      req.body.amount,
      req.file ? req.file.filename : null,
      req.body.time_image,
      req.body.date_image,
      req.body.row,
      req.body.col,
      req.body.seat,
      0
    ];
    con.query(sql, values, (err, result) => {
      if (err) {
        console.error("เกิดข้อผิดพลาดในการจองที่นั่ง:", err);
        return res.status(500).json({ error: "เกิดข้อผิดพลาดในการจองที่นั่ง" });
      } else {
      console.log('จองที่นั่งเรียบร้อยแล้ว');
      return res.json({ status: "จองที่นั่งเรียบร้อยแล้ว" });
      }
    });
  }
  });
};

exports.updateStatus = (req, res) => {
  const id = req.params.id;
  
  const sql = 'UPDATE booking SET `accept` = 1 WHERE `id` = ?';
  
  con.query(sql, [id], (err, result) => {
    if (err) {
      console.error('Error updating boolean value:', err);
      return res.status(500).json({ status: 'Error', message: 'Error updating boolean value' });
    } else {
      console.log('อนุมัติเรียบร้อย');
      return res.json({ status: 'Success', message: 'Boolean value updated successfully' });
    }
  });
  }


exports.booking_users = (req, res) => {
  const values = [
    req.params.id,
    req.body.fromstation,
    req.body.tostation,
    req.body.number,
    req.body.name,
    req.body.email,
    req.body.phone,
    moment.tz(req.body.date, 'Asia/Bangkok').add(7, 'hours').format('YYYY/MM/DD HH:mm:ss'),
    req.body.time,
    req.body.road ,
    req.body.amount,
    req.file ? req.file.filename : null,
    req.body.time_image,
    req.body.date_image,
    req.body.row,
    req.body.col,
    req.body.seat,
    req.body.accept
  ];
  const sql = 'SELECT `id`,`fromstation`, `tostation`, `number`, `name`, `email`, `phone`, `date`, `time`, `road`, `amount`, `image`, `time_image`, `date_image`, `row`, `col`, `seat`, `accept` FROM `booking` WHERE 1';
  con.query(sql, [values], (err, result) => {
    if (err) {
      return res.json({
        status: "Error",
        message: "Failed to retrieve user data",
      });
    }

    if (result.length === 0) {
      return res.json({ status: "Error", message: "User not found" });
    }
    const resultWithGmp7Date = result.map((row) => ({
      ...row,
      date: moment.tz(row.date, 'Asia/Bangkok').format('YYYY/MM/DD'),
    }));

    return res.json({ status: "Success", data: resultWithGmp7Date });
  });
};



exports.showBooking = (req, res) => {
  const values = [
    req.params.id,
    req.body.fromstation,
    req.body.tostation,
    req.body.number,
    req.body.name,
    req.body.email,
    req.body.phone,
    moment.tz(req.body.date, 'Asia/Bangkok').add(7, 'hours').format('YYYY/MM/DD HH:mm:ss'), // แปลงรูปแบบวันที่และเพิ่ม 7 ชั่วโมงใน TimeZone 'Asia/Bangkok'
    req.body.time,
    req.body.road,
    req.body.amount,
    req.file ? req.file.filename : null,
    req.body.time_image,
    req.body.date_image,
    req.body.row,
    req.body.col,
    req.body.seat
  ];

  const sql =
    'SELECT `id`, `fromstation`, `tostation`, `number`, `name`, `email`, `phone`, `date`, `time`, `road`, `amount`, `image`, `time_image`, `date_image`, `row`, `col`, `seat` FROM `booking` WHERE `accept` = 1';

  con.query(sql, [values], (err, result) => {
    if (err) {
      return res.status(500).json({
        status: 'Error',
        message: 'Failed to retrieve user data',
      });
    }

    if (result.length === 0) {
      return res.json({ status: 'Error', message: 'User not found' });
    }

    // แปลงวันที่ให้อยู่ใน TimeZone GMP+7 และเปลี่ยนรูปแบบวันที่
    const resultWithGmp7Date = result.map((row) => ({
      ...row,
      date: moment.tz(row.date, 'Asia/Bangkok').format('YYYY/MM/DD'),
    }));

    return res.json({ status: 'Success', data: resultWithGmp7Date });
  });
};






exports.qrCode = (req, res) => {
  const amount = parseFloat(_.get(req, ["body", "amount"]));
  const mobileNumber = "0969404583";
  const payload = generatePayload(mobileNumber, { amount });

  const option = {
    color: {
      dark: "#000",
      light: "#fff",
    },
  };
  QRCode.toDataURL(payload, option, (err, url) => {
    if (err) {
      console.log("generate fail");
      return res.status(400).json({
        RespCode: 400,
        RespMessage: "bad : " + err,
      });
    } else {
      return res.status(200).json({
        RespCode: 200,
        RespMessage: "good",
        Result: url,
      });
    }
  });
};



exports.getseats = (req, res) => {  
  const query = 'SELECT fromstation, tostation, time, date, row, col FROM booking';
  con.query(query, (err, results) => {
    if (err) {
      console.error('เกิดข้อผิดพลาดในการดึงข้อมูล: ' + err);
      res.status(500).send('เกิดข้อผิดพลาดในการดึงข้อมูล');
      return;
    }
    
    const reservedSeats = results.map((row) => {
      // แปลงวันที่ให้อยู่ใน TimeZone GMT+7
      const dateInGMT7 = moment.tz(row.date, 'Asia/Bangkok').format('YYYY/MM/DD');
      
      return {
        fromstation: row.fromstation,
        tostation: row.tostation,
        time: row.time, // เวลาจาก row.time แบบเดิม
        date: dateInGMT7, // รูปแบบวันที่
        row: row.row,
        col: row.col,
      };
    });
    
    res.json(reservedSeats);
  });
}



exports.deleteBooking = (req, res) => {
  const id = req.params.id;
  const sql = "DELETE FROM booking WHERE id = ?";
  con.query(sql, [id], (err, result) => {
      if (err) return res.json({ Error: "Delete cars Error in sql" });
      return res.json({ Status: "Success" });
  });
};

